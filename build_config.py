'''

Contains configuration data for build.py

'''

__author__ = 't0m50n'

import functools
import os
import io
import re
from collections import namedtuple
from zipfile import ZipFile

BASE_FORUM_URL = 'https://forums.alliedmods.net/'
BUILD_FOLDER = 'build'
PLUGIN_VERSION_REGEX = re.compile(r'#define[^"\nA-Za-z_]*?PLUGIN_VERSION[^"\n]*?"([^"\n]*?)"')

first_scripts = [
    'chaos_mod.sp',
    'chaos_mod_effects.sp',
    'security_entity_limit.sp'
]

def install(path, is_zip, resp):
    if is_zip:
        with ZipFile(io.BytesIO(resp.content)) as z:
            z.extractall(os.path.join(BUILD_FOLDER, path))
    else:
        with open(os.path.join(BUILD_FOLDER, path), 'wb') as f:
            f.write(resp.content)

Dependency = namedtuple('Dependency', ['name', 'post', 'link_predicate', 'install_func', 'scripts'])
dependencies = [
    Dependency(
        name='dhooks',
        post='2588686',
        link_predicate=lambda a: 'sm110.zip' in a.text,
        install_func=functools.partial(install, path='', is_zip=True),
        scripts=[]),

    Dependency(
        name='l4dhooks',
        post='2684862',
        link_predicate=lambda a: '.zip' in a.text,
        install_func=functools.partial(install, path='addons', is_zip=True),
        scripts=['left4dhooks.sp']),

    Dependency(
        name='weapon_damage_mod',
        post='1066911',
        link_predicate=lambda a: a.text == 'Get Source',
        install_func=functools.partial(install,
                                       path='addons/sourcemod/scripting/l4d_damage.sp',
                                       is_zip=False),
        scripts=['l4d_damage.sp']),

    Dependency(
        name='spawn_uncommons',
        post='993523',
        link_predicate=lambda a: a.text == 'Get Source',
        install_func=functools.partial(install,
                                       path='addons/sourcemod/scripting/l4d2_spawnuncommons.sp',
                                       is_zip=False),
        scripts=['l4d2_spawnuncommons.sp']),

    Dependency(
        name='auto_infected_spawner',
        post='954529',
        link_predicate=lambda a: a.text == 'Get Source' and 'l4d2' in a.parent.text,
        install_func=functools.partial(install,
                                       path='addons/sourcemod/scripting/l4d2_autoIS.sp',
                                       is_zip=False),
        scripts=['l4d2_autoIS.sp']),

    Dependency(
        name='weapon_handling_api',
        post='2674761',
        link_predicate=lambda a: 'weapon' in a.text.lower() and '.zip' in a.text,
        install_func=functools.partial(install,
                                       path='',
                                       is_zip=True),
        scripts=['WeaponHandling.sp']),
]