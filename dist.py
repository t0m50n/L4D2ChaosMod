'''

Packages relevant files from the completed build along with sumplementary material into a zip file

'''

__author__ = 't0m50n'

import shutil
import os

import build_config

print('Copying files to dist folder')
shutil.rmtree(build_config.DIST_FOLDER, ignore_errors=True)
shutil.copytree(os.path.join(build_config.BUILD_FOLDER, 'addons'),
                os.path.join(build_config.DIST_FOLDER, 'addons'),
                ignore=shutil.ignore_patterns('*.sp', '*.inc'))
shutil.copytree(os.path.join(build_config.BUILD_FOLDER, 'cfg'),
                os.path.join(build_config.DIST_FOLDER, 'cfg'))
shutil.copytree('configurator', os.path.join(build_config.DIST_FOLDER, 'configurator'))
shutil.copy('README.md', os.path.join(build_config.DIST_FOLDER, 'README.md'))
shutil.copy('CREDITS.md', os.path.join(build_config.DIST_FOLDER, 'CREDITS.md'))
shutil.copy('LICENSE.txt', os.path.join(build_config.DIST_FOLDER, 'LICENSE.txt'))

# Remove empty folders
empty = set()
for root, dirnames, filenames in os.walk(build_config.DIST_FOLDER, topdown=False):
    dirnames = [d for d in dirnames if os.path.join(root, d) not in empty]
    if not dirnames and not filenames:
        empty.add(root)
        os.rmdir(root)

print('Creating zip')
with open(os.path.join(build_config.BUILD_FOLDER, 'addons/sourcemod/scripting/chaos_mod.sp'), 'r') as f:
    version = build_config.PLUGIN_VERSION_REGEX.search(f.read()).group(1)
shutil.make_archive(f'L4D2_Chaos_Mod_v{version}', 'zip', build_config.DIST_FOLDER)