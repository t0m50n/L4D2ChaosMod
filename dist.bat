rmdir /S /Q dist
xcopy /e /i addons dist\addons
rmdir /s /q dist\addons\sourcemod\scripting
xcopy /e /i cfg dist\cfg
xcopy /e /i configurator dist\configurator
copy /y README.md dist\README.md
copy /y CREDITS.md dist\CREDITS.md
powershell Compress-Archive -Force dist\* L4D2_Chaos_Mod.zip