set SP_COMPILER_PATH=E:\SteamLibrary\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\addons\sourcemod\scripting\spcomp.exe
set COPY_DIR=E:\SteamLibrary\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\addons\sourcemod\plugins\
set SCRIPT_DIR=addons\sourcemod\scripting\

"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\chaos_mod.sp"
"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\chaos_mod_effects.sp"

if "%~1"=="tp" (
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\l4d_damage.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\l4d_dissolve_infected.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\l4d2_spawnuncommons.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\l4d2_weaponspawner_v10a.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\security_entity_limit.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\l4d2_autoIS.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\left4dhooks.sp"
	"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\WeaponHandling.sp"
)

move /y "*.smx" "%SCRIPT_DIR%\..\plugins\"
xcopy /y /e /c "%SCRIPT_DIR%\..\..\..\addons" "%COPY_DIR%\..\..\"
xcopy /y /e /c "%SCRIPT_DIR%\..\..\..\cfg" "%COPY_DIR%\..\..\..\cfg"