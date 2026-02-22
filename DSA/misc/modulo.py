#!/usr/bin/env python

# import sys

new_list = ["first", "second", "third", "fourth", "fith"]
# index = int(sys.argv[1])
for index in range(1, 41):
    print(f"my_num: {index}, index: {new_list[(index % len(new_list)) - 1]}")
