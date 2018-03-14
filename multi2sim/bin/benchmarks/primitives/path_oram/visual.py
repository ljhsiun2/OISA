#!/usr/bin/env python

import PyQt4
import numpy as np
import matplotlib
matplotlib.use('qt4agg')
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt


def rgb(val, max_val, min_val):
    r = (val - min_val) / (max_val - min_val)
    g = (max_val - val) / (max_val - min_val)

    return (r*r,g*g,0)

# configs = [(N, B, C) for N in [5,10,20,40,80] for B in [1,2,4,8] for C in [10,20,40,80,160,320]]

with open("output", "r") as output:
    func_dicts = []
    func_dict = {}
    curr_config_idx = 0
    curr_config = configs[curr_config_idx]

    for line in output:
        if line[0] == '|' and 'N' in line:
            curr_N = int(line.split()[3])
            assert curr_N == curr_config[0], "current scanned N is %d while curr_config is %s" %(curr_N, str(curr_config))
        elif line[0] == '|' and 'B' in line:
            curr_B = int(line.split()[3])
            assert curr_B == curr_config[1], "current scanned B is %d while curr_config is %s" %(curr_B, str(curr_config))
        elif line[0] == '|' and 'C' in line:
            curr_C = int(line.split()[3])
            assert curr_C == curr_config[2], "current scanned C is %d while curr_config is %s" %(curr_C, str(curr_config))

        elif line.strip():
            if '%' in line:
                func_name = line.split()[0]
                percent = float(line.split()[2])
                assert '%' == line.split()[3]
                func_dict[func_name] = percent
            elif 'end' in line:
                func_dicts.append([curr_config, func_dict])
                func_dict = {}
                curr_config_idx += 1
                if curr_config_idx < len(configs):
                    curr_config = configs[curr_config_idx]

sort_map = []
max_percent = 0
min_percent = 100
for config, func_dict in func_dicts:
    sort_percent = 0
    for func_name, percent in func_dict.items():
        if "Bitonic" in func_name:
            sort_percent += percent

    if sort_percent > max_percent:
        max_percent = sort_percent
    if sort_percent < min_percent:
        min_percent = sort_percent

    sort_map.append([config, sort_percent])

print max_percent, min_percent

fig = plt.figure()
ax = plt.subplot(111, projection='3d')
# ax = fig.add_subplot(111, projection='3d')
for config, sort_percent in sort_map:
    ax.scatter(config[0], config[1], config[2], c=rgb(sort_percent, max_percent, min_percent))

ax.set_xlabel('N')
ax.set_ylabel('B')
ax.set_zlabel('C')

# ax.set_xscale('log')
# ax.set_yscale('log')
# ax.set_zscale('log')

plt.savefig('graph.png')

plt.show()
