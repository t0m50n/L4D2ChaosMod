'''
Build script for chaosmod.

Downloads third party plugins, compiles chaosmod and moves plugins to the provided location

Tested on Windows 10 with python 3.8.5 and SourcePawn Compiler 1.10.0.6460

'''

__author__ = 't0m50n'

import argparse
import subprocess
import glob
import shutil
import os
from collections import namedtuple


def parse_args():
    parser = argparse.ArgumentParser(description='Downloads third party plugins, compiles chaosmod \
                                                  and moves plugins to the provided location')
    parser.add_argument('SP_COMP', action='store', help='Path to SourcePawn compiler')
    parser.add_argument('-d', dest='INSTALL_PATH', action='store',
                        help='Where to install files after compilation. Should point to the root \
                              of the server eg. "C:/Program Files (x86)/Steam/steamapps/common/\
                              Left 4 Dead 2 Dedicated Server". If ommitted, installation is \
                              skipped.')
    parser.add_argument('-t', dest='THIRD_PARTY', action='store_true',
                        help='If provided then third party plugins will be downloaded and \
                              compiled')

    return parser.parse_args()

def compile_scripts(comp_path, scripts):
    for s in scripts:
        # Must use backslashes here or spcomp doesn't find includes correctly
        subprocess.run([comp_path, os.path.join('addons\\sourcemod\\scripting\\', s)], check=True)
    
    for plugin in glob.glob('*.smx'):
        dest_path = os.path.join('addons/sourcemod/plugins', plugin)
        if os.path.isfile(dest_path):
            os.remove(dest_path)
        shutil.move(plugin, dest_path)

def install(install_path):
    CopyOperation = namedtuple('CopyOperation', ['src', 'dst'])
    copy_ops = [
        CopyOperation(src='addons', dst='left4dead2/addons'),
        CopyOperation(src='cfg', dst='left4dead2/cfg'),
    ]
    
    for c in copy_ops:
        try:
            shutil.copytree(c.src, os.path.join(install_path, c.dst), dirs_exist_ok=True)
        except shutil.Error as e:
            print('WARNING: The following copy errors were ignored while installing plugins:')
            for (src, dst, reason) in e.args[0]:
                print(f'src={src} dst={dst} reason={reason}')

if __name__ == '__main__':
    args = parse_args()

    scripts = [
        'chaos_mod.sp',
        'chaos_mod_effects.sp'
    ]
    if args.THIRD_PARTY:
        scripts += [
            'l4d_damage.sp',
            'l4d2_spawnuncommons.sp',
            'security_entity_limit.sp',
            'l4d2_autoIS.sp',
            'left4dhooks.sp',
            'WeaponHandling.sp'
        ]

    compile_scripts(args.SP_COMP, scripts)

    if args.INSTALL_PATH is not None:
        install(args.INSTALL_PATH)