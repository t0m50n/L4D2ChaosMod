set SP_COMPILER_PATH=E:\SteamLibrary\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\addons\sourcemod\scripting\spcomp.exe
set COPY_DIR=E:\SteamLibrary\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\addons\sourcemod\plugins\
set SCRIPT_DIR=addons\sourcemod\scripting\

"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\chaos_mod.sp"
"%SP_COMPILER_PATH%" "addons\sourcemod\scripting\chaos_mod_effects.sp"

move /y "*.smx" "%SCRIPT_DIR%\..\plugins\"
xcopy /y /e /c "%SCRIPT_DIR%\..\..\..\addons" "%COPY_DIR%\..\..\"
xcopy /y /e /c "%SCRIPT_DIR%\..\..\..\cfg" "%COPY_DIR%\..\..\..\cfg"