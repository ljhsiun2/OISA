#!/usr/bin/env python3

import numpy

PATH = "/home/Jiyong_Yu/Research/multi2sim/samples/x86/bitonic_osort/static/"

TRACE_FILE      = PATH + "trace.txt"
DISASM_FILE     = PATH + "disasm.txt"
EXE_INSTR_FILE  = PATH + "debug_isa.txt.no_sim_flag"


committed_instrs = []

def calcCommitTime():
    with open(EXE_INSTR_FILE) as exe_instr_file:
        for line in exe_instr_file:
            instr = ((line[line.find(':')+1:]).split('(')[0]).strip()
            addr = (line.split()[2])[:-1]
            committed_instrs.append([addr, instr, 0])

    num_committed_instr = 0
    clock = 0
    with open(TRACE_FILE) as trace_file:
        lines = trace_file.readlines()
        back_cnt = 0
        for line in lines:
            if line[0] == 'c':
                clock = int(line.split('=')[1])
                print ("clock = ", clock)
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
                                        print ("exe_instr#:", num_committed_instr, "trace_id:", id_str, "commit: ", committed_instr)
                                        committed_instrs[num_committed_instr][2] = clock
                                        num_committed_instr = num_committed_instr + 1
                            break



calcCommitTime()



