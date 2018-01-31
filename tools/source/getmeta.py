#!/usr/bin/env python3

# by SuperR. @XDA

import sys, os, struct, argparse, glob

parser = argparse.ArgumentParser(description='Retrieve file contexts, capabilitiess, and permissions from a mounted "output" directory.')
parser.add_argument('directory', help='Path to mounted "output" directory')
parser.add_argument('partition', help='Name of the partition (Ex. system)')

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-s', '--screen', action='store_true', help='Display result on the screen.')
group.add_argument('-o', '--outfile', help='Write result to file.')

args = parser.parse_args()

if os.name == 'nt':
    print('\nThis program will not provide the desired results in Windows\n')
    sys.exit()

indir = args.directory

if not glob.glob(indir+'/*'):
    print('\n'+indir+' does not exist or is empty.\n')
    sys.exit()

for i in glob.glob(indir+'/**', recursive=True):
    if os.path.islink(i):
        continue

    try:
        b = os.getxattr(i, "security.selinux").replace(b'\x00', b'')
        con = str(b.decode())
    except:
        con = 'u:object_r:'+args.partition+'_file:s0'

    try:
        b = os.getxattr(i, "security.capability")
        cap = hex(int(list(struct.unpack("<IIIII", b))[1]))
    except:
        cap = '0x0'

    perm = os.stat(i)
    mode = str(oct(perm.st_mode))[-4:]
    uid = str(perm.st_uid)
    gid = str(perm.st_gid)

    if args.screen:
        print(i.replace(indir, args.partition), uid, gid, mode, cap, con)
    elif args.outfile:
        with open(args.outfile, 'a', newline='\n') as text_file:
            print(i.replace(indir, args.partition), uid, gid, mode, cap, con, file=text_file)