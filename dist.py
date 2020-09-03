'''

Packages relevant files from a completed build along with sumplementary material into a zip file

'''

__author__ = 't0m50n'

import shutil
import os

import build_config

shutil.rmtree('dist', ignore_errors=True)
shutil.copytree(os.path.join(build_config.BUILD_FOLDER, 'addons'),
                os.path.join('dist/addons'),
                dirs_exist_ok=True,
                ignore=shutil.ignore_patterns('*.sp', '*.inc'))
shutil.copytree(os.path.join(build_config.BUILD_FOLDER, 'cfg'), 'dist/cfg')
shutil.copytree('configurator', 'dist/configurator')
shutil.copy('README.md', 'dist/README.md')
shutil.copy('CREDITS.md', 'dist/CREDITS.md')
shutil.copy('LICENSE.txt', 'dist/LICENSE.txt')

# Remove empty folders
empty = set()
for root, dirnames, filenames in os.walk('dist', topdown=False):
    dirnames = [d for d in dirnames if os.path.join(root, d) not in empty]
    if not dirnames and not filenames:
        empty.add(root)
        os.rmdir(root)

with open(os.path.join(build_config.BUILD_FOLDER, 'addons/sourcemod/scripting/chaos_mod.sp'), 'r') as f:
    version = build_config.PLUGIN_VERSION_REGEX.search(f.read()).group(1)
shutil.make_archive(f'L4D2_Chaos_Mod_v{version}', 'zip', 'dist')