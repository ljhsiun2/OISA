#!/usr/bin/env python3

import numpy
import os
import contextlib

CXX_FLAGS = " -O3 "

MULTI2SIM_PATH = "/home/Jiyong_Yu/Research/OISA/multi2sim/bin/m2s"
CUR_DIR = os.getcwd() + "/"
PAR_DIR = os.path.dirname(os.getcwd()) + "/"

EXECUTABLE_NAME = "oram"

EXECUTABLE      = CUR_DIR + EXECUTABLE_NAME
TRACE_PACKAGE   = CUR_DIR + "trace.gz"
TRACE_FILE      = CUR_DIR + "trace"
DISASM_FILE     = CUR_DIR + "disasm"
EXE_INSTR_FILE  = CUR_DIR + "debug_isa.no_sim_flag"



def generateFile(param):
    print ("=== Generate files ===")
    assert isinstance(param, str)

    # compile C program
    # with contextlib.suppress(FileNotFoundError):
        # os.remove(EXECUTABLE)
    # os.system("gcc -m32 " + CUR_DIR + "oram.c "             \
                          # + CUR_DIR + "main.c "             \
                          # + PAR_DIR + "sort/bitonic_sort.c" \
                          # + " -o " + EXECUTABLE + " " + CXX_FLAGS)

    # Generate disassembly
    with contextlib.suppress(FileNotFoundError):
        os.remove(DISASM_FILE)
    os.system(MULTI2SIM_PATH + " --x86-disasm " + EXECUTABLE + " > " + DISASM_FILE)

    ## Generate debug isa file
    with contextlib.suppress(FileNotFoundError):
        os.remove(EXE_INSTR_FILE)
    os.system(MULTI2SIM_PATH + " --x86-debug-isa " + EXE_INSTR_FILE + " " + EXECUTABLE + " " + param)

    ## Generate trace file
    with contextlib.suppress(FileNotFoundError):
        os.remove(TRACE_PACKAGE)
    os.system(MULTI2SIM_PATH + " --x86-sim detailed --trace " + TRACE_PACKAGE + " " + EXECUTABLE + " " + param)

    ## Uncompress the generated .gz trace package
    with contextlib.suppress(FileNotFoundError):
        os.remove(TRACE_FILE)
    os.system("gunzip --keep " + TRACE_PACKAGE)


def calcCommitTime():

    print ("=== Calculate commit time ===")
    committed_instrs = []

    with open(EXE_INSTR_FILE) as exe_instr_file:
        for line in exe_instr_file:
            instr = ((line[line.find(':')+1:]).split('(')[0]).strip()
            addr = (line.split()[2])[:-1]
            committed_instrs.append([addr, instr, 0])

    ## Find committed timestamp for all committed instructions
    num_committed_instr = 0
    clock = 0
    with open(TRACE_FILE) as trace_file:
        lines = trace_file.readlines()
        back_cnt = 0
        for line in lines:
            if line[0] == 'c':
                clock = int(line.split('=')[1])
            else:
                if "\"co\"" in line:
                    uop_id = int((line.split('=')[1]).split()[0])
                    # search for uop_id in trace_file_copy
                    search_str = "id="+str(uop_id)
                    while True:
                        line_back = lines[back_cnt]
                        back_cnt = back_cnt + 1
                        if "new_inst" in line_back and search_str in line_back:
                            if " asm" in line_back:
                                id_str = line_back.split()[1]
                                substrings = line_back.split("\"")
                                for i in range(len(substrings)):
                                    if " asm" in substrings[i]:
                                        committed_instr = substrings[i+1]
                                        assert committed_instr == committed_instrs[num_committed_instr][1], "instr#: %d, id: %s, trace: %s, exe: %s"% (num_committed_instr, id_str, committed_instr, committed_instrs[num_committed_instr][1])
                                        # print ("exe_instr#:", num_committed_instr, "trace_id:", id_str, "commit: ", committed_instr)
                                        committed_instrs[num_committed_instr][2] = clock
                                        num_committed_instr = num_committed_instr + 1
                            break

    ## Record all starting/ending address of all perspective functions
    func_list = []
    addr_map = {}
    with open(DISASM_FILE) as disasm_file:
        lines = disasm_file.readlines()
        num_lines = len(lines)
        line_cnt = 0
        while line_cnt < num_lines:
            if '<' in lines[line_cnt] and '>' in lines[line_cnt]:
                func = lines[line_cnt][lines[line_cnt].find('<')+1 : lines[line_cnt].find('>')]
                if func[0].isupper() or func == "main":
                    func_list.append(func)
                    # record the start & end  address of this function
                    line_cnt = line_cnt + 1
                    begin_addr = lines[line_cnt].split(':')[0].strip()
                    addr_map[begin_addr] = ['enter', func]

                    end_addr = -1
                    line_cnt = line_cnt + 1
                    while lines[line_cnt].strip() != "":
                        if "ret" in lines[line_cnt]:
                            end_addr = lines[line_cnt].split(':')[0].strip()
                            addr_map[end_addr] = ['leave', func]
                        line_cnt = line_cnt + 1

            line_cnt = line_cnt + 1

    print (addr_map)


    ## Search for all port addresses, build the transit stack
    transit_stack = []
    call_stack = [["start"]]
    for instr_tup in committed_instrs:
        addr, instr, timestamp = instr_tup
        if addr in addr_map:
            op, func = addr_map[addr]
            # print (op, func)
            if op == 'enter':
                transit_stack.append([call_stack[-1][-1], func, timestamp])
                if "call" in prev_instr:
                    call_stack.append([func])
                else:
                    call_stack[-1].append(func)
            elif addr_map[addr][0] == 'leave':
                assert call_stack[-1][-1] == func, "call stack is: %s; function is: %s" %(str(call_stack), func)
                for i in range(len(call_stack[-1])-1):
                    transit_stack.append([call_stack[-1][-1-i], call_stack[-1][-2-i], timestamp])
                transit_stack.append([call_stack[-1][0], call_stack[-2][-1], timestamp])
                call_stack.pop()
            else:
                assert 0
        prev_instr = instr

    # print ("call stack is: ", call_stack)
    assert call_stack[0][0] == "start" and len(call_stack) == 1, "call stack is: %s" %(str(call_stack))
    # for i in transit_stack:
        # print (i)

    ## Use the transit stack to compute the time spent on each function
    func_time = {}
    for func in func_list:
        func_time[func] = 0
    func_time["before_main"] = transit_stack[0][2]
    for i in range(len(transit_stack) - 1):
        curr_tx = transit_stack[i]
        next_tx = transit_stack[i+1]
        # print(curr_tx, next_tx)
        assert curr_tx[1] == next_tx[0]
        func_time[curr_tx[1]] = func_time[curr_tx[1]] +  int(next_tx[2]) - int(curr_tx[2])

    total_cycles = 0
    for func, time in func_time.items():
        total_cycles = total_cycles + time

    func_percent = {}
    for func, time in func_time.items():
        func_percent[func] = float(time) / total_cycles

    print (func_time)
    for func, percent in func_percent.items():
        print (func, ":", percent * 100, "%")

    print ("where main happens: ", committed_instrs[87019][2])
    print ("where all end: ", committed_instrs[-1][2])


generateFile("")
calcCommitTime()



