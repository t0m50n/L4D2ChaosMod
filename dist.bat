rmdir /S /Q dist
xcopy /e /i addons dist\addons
xcopy /e /i cfg dist\cfg
rmdir /S /Q dist\addons\sourcemod\scripting
powershell Compress-Archive -Force dist\* L4D2_Chaos_Mod.zip