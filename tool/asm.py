# date: 2020/11/14
# by:   kun

import re

noinfo = True

def getinstr(input_instr):
    op_dict = {'add': '000000', 'sub': '000000', 'and': '000000', 'or': '000000', 'xor': '000000',
               'slt': '000000', 'sw': '101011', 'lw': '100011', 'beq': '000100', 'j': '000010'}
    op_type_dict = {'add': 'r', 'sub': 'r', 'and': 'r', 'or': 'r', 'xor': 'r',
                    'slt': 'r', 'sw': 'i', 'lw': 'i', 'beq': 'i', 'j': 'j'}
    func_dict = {'add': '100000', 'sub': '100010', 'and': '100100',
                 'or': '100101', 'xor': '100110', 'slt': '101010'}

    op = input_instr.split(' ', 1)[0].lower().strip()
    others = input_instr.split(' ', 1)[1].lower().strip()
    code = op_dict[op]

    if op_type_dict[op] == 'r':
        match = re.match(
            r'\$(\d{1,2}),\s*\$(\d{1,2}),\s*\$(\d{1,2})', others, re.I)
        rs = match.group(2)
        rt = match.group(3)
        rd = match.group(1)
        rs = '{0:05b}'.format(int(rs))
        rt = '{0:05b}'.format(int(rt))
        rd = '{0:05b}'.format(int(rd))
        code = code + rs + rt + rd + '00000' + func_dict[op]

    if op_type_dict[op] == 'i':
        if op == 'beq':
            match = re.match(
                r'\$(\d{1,2}),\s*\$(\d{1,2}),\s*(-?\d*)', others, re.I)
            rs = match.group(1)
            rt = match.group(2)
            offset = match.group(3)
        if op == 'lw' or op == 'sw':
            match = re.match(
                r'\$(\d{1,2}),\s*(-?\d*)\(\$(\d{1,2})\)', others, re.I)
            rt = match.group(1)
            offset = match.group(2)
            rs = match.group(3)
        rs = '{0:05b}'.format(int(rs))
        rt = '{0:05b}'.format(int(rt))
        offset = int(offset)
        if offset < 0:
            offset = bin(int(offset) + (1 << 32))[18:]
        else:
            offset = bin(int(offset) + (1 << 32))[19:]
        code = code + rs + rt + offset

    if op_type_dict[op] == 'j':
        num = input_instr.split()[1]
        code = code + '{0:026b}'.format(int(num))  # cannot < 0

    hexinstr = '{0:08x}'.format(int(code, 2))

    if(noinfo):
        print(hexinstr.upper(), end='\n')
    else:
        print('op type: ', op_type_dict[op])
        print('code bin: ', code)
        print('code hex: ',  hexinstr.upper(), end='\n\n')


def parsecomment(inputstr):
    return inputstr.split('//',1)[0]


if __name__ == "__main__":
    inputstr = parsecomment(input())
    while (inputstr != "q"):
        getinstr(inputstr)
        inputstr = parsecomment(input())
