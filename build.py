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
import json
import re
from collections import namedtuple, defaultdict
from urllib.parse import urljoin
from datetime import datetime

import requests
from bs4 import BeautifulSoup

import build_config

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

def download_dependencies(dependancies):
    try:
        with open('version_log.json', 'r') as f:
            log = defaultdict(dict, json.load(f))
    except OSError:
        log = defaultdict(dict)
    
    for d in dependancies:
        print(f'Downloading {d.name}')
        html = requests.get(build_config.BASE_FORUM_URL + 'showpost.php?p=' + d.post)
        soup = BeautifulSoup(html.text, 'html.parser')

        url = next(a['href'] for a in soup.find_all('a') if d.link_predicate(a))
        url = urljoin(build_config.BASE_FORUM_URL, url)
        resp = requests.get(url)

        d.install_func(resp=resp)
        
        version = get_dependancy_version(d, resp)
        if 'version' in log[d.name] and log[d.name]['version'] != version:
            print(f'Dependency {d.name} was updated from {log[d.name]["version"]} to {version}')
        log[d.name]['date'] = datetime.utcnow()
        log[d.name]['version'] = version
    
    with open('version_log.json', 'w') as f:
        json.dump(log, f, sort_keys=True, indent=4, default=str)

def get_dependancy_version(dependancy, resp):
    if not dependancy.scripts:
        # Use filename as version
        return re.search(r'filename="?(.+)\.', resp.headers['content-disposition']).group(1)

    # Get version from source code
    script_path = os.path.join(build_config.BUILD_FOLDER, 'addons/sourcemod/scripting', dependancy.scripts[0])
    with open(script_path, 'r') as f:
        content = f.read()
    
    version = build_config.PLUGIN_VERSION_REGEX.search(content)
    if version is None:
        return '???'
    else:
        return version.group(1)

def compile_scripts(comp_path, scripts):
    # Must use backslashes here or spcomp doesn't find includes correctly
    script_dir = os.path.join(build_config.BUILD_FOLDER, 'addons\\sourcemod\\scripting')
    for s in scripts:
        subprocess.run([comp_path,
                        os.path.join(script_dir, s),
                        '-i',
                        os.path.join(script_dir, 'include')], check=True)
    
    for plugin in glob.glob('*.smx'):
        dest_path = os.path.join(build_config.BUILD_FOLDER, 'addons/sourcemod/plugins', plugin)
        if os.path.isfile(dest_path):
            os.remove(dest_path)
        shutil.move(plugin, dest_path)

def copy_to_server(install_path):
    CopyOperation = namedtuple('CopyOperation', ['src', 'dst'])
    copy_ops = [
        CopyOperation(src='addons', dst='left4dead2/addons'),
        CopyOperation(src='cfg', dst='left4dead2/cfg'),
    ]
    
    for c in copy_ops:
        try:
            shutil.copytree(os.path.join(build_config.BUILD_FOLDER, c.src), os.path.join(install_path, c.dst),
                            dirs_exist_ok=True, ignore=shutil.ignore_patterns('*.sp', '*.inc'))
        except shutil.Error as e:
            print('WARNING: The following copy errors were ignored while installing plugins:')
            for (src, dst, reason) in e.args[0]:
                print(f'src={src} dst={dst} reason={reason}')

if __name__ == '__main__':
    args = parse_args()

    print('Copying chaosmod source files to build folder')
    shutil.copytree('addons', os.path.join(build_config.BUILD_FOLDER, 'addons'), dirs_exist_ok=True)
    shutil.copytree('cfg', os.path.join(build_config.BUILD_FOLDER, 'cfg'), dirs_exist_ok=True)

    if args.THIRD_PARTY:
        print('Downloading dependencies to build folder')
        download_dependencies(build_config.dependencies)

    # Generate list of scripts to be compiled
    scripts = build_config.first_scripts
    if args.THIRD_PARTY:
        for d in build_config.dependencies:
            scripts += d.scripts

    print('Compiling scripts')
    compile_scripts(args.SP_COMP, scripts)

    # Copy files to your server installation
    if args.INSTALL_PATH is not None:
        print('Copying files to server install')
        copy_to_server(args.INSTALL_PATH)