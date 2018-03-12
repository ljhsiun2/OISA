#!/usr/bin/env python3

import numpy

PATH = "/home/Jiyong_Yu/Research/multi2sim/samples/x86/bitonic_osort/dynamic/"

TRACE_FILE      = PATH + "trace.txt"
DISASM_FILE     = PATH + "disasm.txt"
EXE_INSTR_FILE  = PATH + "debug_isa.txt.no_sim_flag"


committed_instrs = []

def calcCommitTime():
    with open(EXE_INSTR_FILE) as exe_instr_file:
        for line in exe_instr_file:
            instr = ((line[line.find(':')+1:]).split('(')[0]).strip()
            addr = (line.split()[2])[:-1]
            committed_instrs.append([addr,instr, 0])

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
    with open(DISASM_FILE) as disasm_file:
        lines = disasm_file.readlines()
        num_lines = len(lines)
        line_cnt = 0
        while line_cnt < num_lines:
            if '<' in lines[line_cnt] and '>' in lines[line_cnt]:
                func = lines[line_cnt][lines[line_cnt].find('<')+1 : lines[line_cnt].find('>')]
                if func[0].isupper() or func == "main":
                    # record the start & end  address of this function
                    line_cnt = line_cnt + 1
                    begin_addr = lines[line_cnt].split(':')[0].strip()
                    end_addr = begin_addr
                    line_cnt = line_cnt + 1
                    while "ret" not in lines[line_cnt]:
                        line_cnt = line_cnt + 1
                    end_addr = lines[line_cnt].split(':')[0].strip()
                    func_list.append([func, begin_addr, end_addr])

            line_cnt = line_cnt + 1
    
    addr_map = {}
    for tup in func_list:
        addr_map[tup[1]] = ['enter', tup[0]]
        addr_map[tup[2]] = ['leave', tup[0]]

    # print (addr_map)

    ## Search for all port addresses, build the transit stack
    transit_stack = []
    call_stack = ["start"]
    for instr_tup in committed_instrs:
        addr, instr, timestamp = instr_tup
        if addr in addr_map:
            op, func = addr_map[addr]
            # print (op, func)
            if op == 'enter':
                transit_stack.append([call_stack[-1], func, timestamp])
                call_stack.append(func)
            elif addr_map[addr][0] == 'leave':
                assert call_stack[-1] == func, "top of call stack is: %s; function is: %s" %(call_stack[-1], func)
                call_stack.pop()
                transit_stack.append([func, call_stack[-1], timestamp])
            else:
                assert 0

    # print ("call stack is: ", call_stack)
    assert call_stack[0] == "start" and len(call_stack) == 1
    # for i in transit_stack:
        # print (i)

    ## Use the transit stack to compute the time spent on each function
    func_time = {}
    for func_tup in func_list:
        func_time[func_tup[0]] = 0
    for i in range(len(transit_stack) - 1):
        curr_tx = transit_stack[i]
        next_tx = transit_stack[i+1]
        print(curr_tx, next_tx)
        assert curr_tx[1] == next_tx[0]
        func_time[curr_tx[1]] = func_time[curr_tx[1]] +  int(next_tx[2]) - int(curr_tx[2])

    print (func_time)



calcCommitTime()



