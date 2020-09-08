# L4D2 Chaos Mod Build Guide

- Tested on Windows 10
- If you have/are used to VSCode then it will make the setup a bit easier

## Prerequisites

- SourcePawn Compiler 1.10+
- Python 3.8+

## Steps

1. Clone repo
    ```console
    git clone https://github.com/t0m50n/L4D2ChaosMod.git
    cd L4D2ChaosMod
    ```
2. Create python environment and install requirements:
   ```console
   path\to\python3.8 -m venv pyenv
   .\pyenv\Scripts\activate
   pip install -r requirements.txt
   ```
3. Run a build using the provided build.py script. Make sure the environment in step 2 is still active. See .vscode\tasks.json for examples of what I use as parameters. Your first build will need to include the -t parameter to fetch third party scripts. Use the below command to print help information.
   ```console
   python build.py -h
   ```
4. Once a build is complete you can run the dist.py script to create the final release zip
   ```console
   python dist.py
   ```

## Other Things
- The build and dist scripts can be further configured using the build_config.py file
- version_log.json keeps track of the dependancy versions fetched for the last build if the -t parameter was provided.