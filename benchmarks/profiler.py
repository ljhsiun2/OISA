#!/usr/bin/env python3

import numpy
import os
import sys
import contextlib
from collections import deque
from datetime import datetime


MULTI2SIM_PATH = "../multi2sim/bin/m2s"
CUR_DIR = os.getcwd() + "/"

EXECUTABLE_NAME = "ofind_max"

EXECUTABLE      = CUR_DIR + EXECUTABLE_NAME
TRACE_PACKAGE   = CUR_DIR + "trace.gz"
TRACE_FILE      = CUR_DIR + "trace"
DISASM_FILE     = CUR_DIR + "disasm"
EXE_INSTR_FILE  = CUR_DIR + "debug_isa.no_sim_flag"

MAKE_OPTIONS = "dynamic"


class Unbuffered(object):
    def __init__(self, stream):
        self.stream = stream
    def write(self, data):
        self.stream.write(data)
        self.stream.flush()
    def writelines(self, data):
        self.stream.writelines(data)
        self.stream.flush()
    def __getattr__(self, attr):
        return getattr(self.stream, attr)


sys.stdout = Unbuffered(sys.stdout)


def compileProgram():
    print ("=== Compile program ===")

    ## compile C program (CHANGE the option here!)
    if MAKE_OPTIONS == "dynamic":
        os.system("make sim_opt")
    elif MAKE_OPTIONS == "static":
        os.system("make sim_opt_static")
    else:
        assert 0

    ## Generate disassembly
    with contextlib.suppress(FileNotFoundError):
        os.remove(DISASM_FILE)
    os.system(MULTI2SIM_PATH + " --x86-disasm " + EXECUTABLE + " > " + DISASM_FILE)

def executeProgram(param):
    print ("=== Run Program with param (", param, ") at ", str(datetime.now()), " ===")
    assert isinstance(param, str)

    ## Generate debug isa file
    with contextlib.suppress(FileNotFoundError):
        os.remove(EXE_INSTR_FILE)
    os.system(MULTI2SIM_PATH + " --x86-config x86_config.ini --mem-config mem_config.ini --x86-debug-isa " + EXE_INSTR_FILE + " " + EXECUTABLE + " " + param)

    ## Generate trace file
    with contextlib.suppress(FileNotFoundError):
        os.remove(TRACE_PACKAGE)
    os.system(MULTI2SIM_PATH + " --x86-config x86_config.ini --mem-config mem_config.ini --x86-sim detailed --trace " + TRACE_PACKAGE + " " + EXECUTABLE + " " + param)

    ## Uncompress the generated .gz trace package
    with contextlib.suppress(FileNotFoundError):
        os.remove(TRACE_FILE)
    os.system("gunzip --keep " + TRACE_PACKAGE)
    os.system("rm " + TRACE_PACKAGE)


def calcCommitTime(param):

    print ("=== Calculate commit time at ", str(datetime.now()), " ===")

    ## Record all starting address of all function from Disassembly file
    func_list = []
    entrance_func_map = {}
    with open(DISASM_FILE) as disasm:
        for line in disasm:
            if '<' in line and '>' in line:
                func = line[line.find('<')+1 : line.find('>')]
                if MAKE_OPTIONS == "dynamic" or func == "main" or func[0].isupper():
                    func_list.append(func)
                    entrance = int(line.split()[0], 16)
                    entrance_func_map[entrance] = func

    ## Find all call/ret instruction from debug-isa file
    committed_instrs = []
    num_calls = 0
    num_rets  = 0
    record_target_addr = False
    record_ret_addr = False
    with open(EXE_INSTR_FILE) as exe_instr_file:
        for line in exe_instr_file:
            instr = ((line[line.find(':')+1:]).split('(')[0]).strip()
            addr = int((line.split()[2])[:-1], 16)
            if record_target_addr:
                record_target_addr = False
                committed_instrs[-1][-2] = addr
            if record_ret_addr:
                record_ret_addr = False
                committed_instrs[-1][-1] = addr
            if "call" in instr:
                num_calls = num_calls + 1
                record_target_addr = True
                if "DWORD" in instr:
                    ret_addr = addr + int((line.split('(')[1]).split()[0])
                    committed_instrs.append([addr, instr, 0, "DEADBEEF", ret_addr])
                else:
                    ret_addr = addr + int((line.split('(')[1]).split()[0])
                    committed_instrs.append([addr, instr, 0, "DEADBEEF", ret_addr])
            if "ret" in instr:
                num_rets  = num_rets + 1
                record_ret_addr = True
                committed_instrs.append([addr, instr, 0, 0, "DEADBEEF"])

    ## Find committed timestamp from trace file
    trace_buffer = deque([])
    clock = 0
    num_committed_instr = 0
    with open(TRACE_FILE) as trace_file:
        for line in trace_file:
            if line[0] == 'c':
                clock = int(line.split('=')[1])
            else:
                if "\"co\"" in line: # find this committed instruction in trace_buffer
                    instr_id = int((line.split('=')[1]).split()[0])
                    while len(trace_buffer) > 0:
                        oldest_instr = trace_buffer.popleft()
                        if oldest_instr[0] > instr_id:
                            trace_buffer.appendleft(oldest_instr)
                            break
                        elif oldest_instr[0] == instr_id:
                            assert committed_instrs[num_committed_instr][1] == oldest_instr[1]
                            committed_instrs[num_committed_instr][2] = oldest_instr[2]
                            num_committed_instr = num_committed_instr + 1
                            break
                else:
                    if " asm" in line:
                        instr_id = int((line.split('=')[1]).split()[0])
                        instr    = line[line.index("asm")+5:line.index("uasm")-2]
                        if "call" in instr or "ret" in instr:
                            trace_buffer.append([instr_id, instr, clock])


    ## Search for all port addresses, build the transit stack
    transit_stack = []
    if "static" in MAKE_OPTIONS:
        call_stack = [["_start", []]]
    else:
        call_stack = [["before_all", []]]

    for instr_info in committed_instrs:
        addr, instr, clock, target, ret_addr = instr_info
        if "call" in instr:
            # print (hex(addr), "call: jump to ", hex(target))
            if target != ret_addr:
                call_stack[-1][1].append(ret_addr)
                if target in entrance_func_map:
                    transit_stack.append([call_stack[-1][0], entrance_func_map[target], clock])
                    call_stack.append([entrance_func_map[target], []])

        elif "ret" in instr:
            # print (hex(addr), "ret: jump to ", hex(ret_addr))
            if len(call_stack[-1][1]) == 0:
                if call_stack[-2][1][-1] == ret_addr:
                    transit_stack.append([call_stack[-1][0], call_stack[-2][0], clock])
                    call_stack.pop()
                    call_stack[-1][1].pop()
                # else:
                    # print ("false ret! jump to ", hex(ret_addr))
            else:
                if call_stack[-1][1][-1] == ret_addr:
                    call_stack[-1][1].pop()
                # else:
                    # print ("false ret! jump to ", hex(ret_addr))

        else:
            assert 0, "current instruction is %s, which is not call or ret" %(instr)

        # print ([[x[0], [hex(i) for i in x[1]]] for x in call_stack])


    # assert call_stack[0][0] == "before_all" and len(call_stack) == 1, "call stack is: %s" %(str(call_stack))

    ## Use the transit stack to compute the time spent on each function
    func_time = {}
    for func in func_list:
        func_time[func] = 0

    if "static" in MAKE_OPTIONS:
        func_time["_start"] = transit_stack[0][2]
    else:
        func_time["before_all"] = transit_stack[0][2]
    for i in range(len(transit_stack) - 1):
        curr_tx = transit_stack[i]
        next_tx = transit_stack[i+1]
        # print(curr_tx, next_tx)
        assert curr_tx[1] == next_tx[0], "FUCK!!!"
        func_time[curr_tx[1]] = func_time[curr_tx[1]] +  int(next_tx[2]) - int(curr_tx[2])

    total_cycles = 0
    for func, time in func_time.items():
        total_cycles = total_cycles + time

    profile_name = "output_" + param.replace(' ', '_') + ".txt"
    with open(profile_name, "a") as output: 
        for func, time in sorted(func_time.items(), key=lambda x: x[1], reverse=True):
            percent = float(time) / total_cycles * 100
            output.write(func + " : " + str(percent) + "% = " + str(time) + " cycles\n")

        # for i in transit_stack:
            # output.write(str(i)+"\n")

        output.write("======== end =========\n")

    # print ("where main happens: ", committed_instrs[87019][2])
    # print ("where all end: ", committed_instrs[-1][2])


######################################################################
##
##      Put your test code here
##
######################################################################
compileProgram()
# for N in [2**8, 2**11, 2**14, 2**17, 2**20]:
    # for B in [1, 128, 1024]:
        # for sort_code in [0, 1]:
            # with open("output.txt", "a") as output:
                # sort_scheme = 'MERGE_SORT' if sort_code == 0 else 'BITONIC_SORT'

                # output.write("\n\n=============================================\n")
                # output.write("||               Z = 4                        ||\n")
                # output.write("||               C = 200                      ||\n")
                # output.write("||               N = " + str(N) + "\t              ||\n")
                # output.write("||               B = " + str(B) + "\t              ||\n")
                # output.write("||     Sort Scheme = " + sort_scheme + "      ||\n")
                # output.write("=============================================\n")

            # executeProgram(str(N) + " " + str(B) + " " + str(sort_code))
            # calcCommitTime()

# param = "1048576 128 0"
param = ""
executeProgram(param)
calcCommitTime(param)


