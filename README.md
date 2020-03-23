# L4D2 Chaos Mod

## Introduction

Inspired by the chaos mods made for the Grand Theft Auto series - I decided to make a version for Left 4 Dead 2. The idea behind Chaos Mod is to enable random effects at regular intervals during play. This can result in some funny situations which will only get more varied as I add more effects.

This mod is intended to be run as a sourcemod plugin on a dedicated server. This means it's possible to have a full server of people playing with the mod enabled. Note that only the server needs the mod installed and the clients can join with a vanilla copy of Left 4 Dead 2.

## Prerequisites

Left 4 Dead 2 or Left 4 Dead 2 dedicated server with sourcemod installed.

## Installation

1. Download latest [release](https://github.com/t0m50n/L4D2ChaosMod/releases)
2. Extract zip
3. Copy the cfg and addons folders to %l4d2 install dir%\left4dead2\ and overwrite

## Configuration
1. Open configurator\index.html in a browser. (Tested on Chrome, Firefox and Edge)
2. Choose which effects you want to be enabled
3. Copy the generated text and paste it into %l4d2 install dir%\left4dead2\addons\sourcemod\configs\effects.cfg overwriting the previous contents.
4. The generated cfg can be pasted back into the configurator to turn effects on and off in the future.

The following cvars can also be changed in the server console:
```
// Enable/Disable Chaos Mod
// -
// Default: "1"
chaosmod_enabled "1"

// Time in seconds a long effect should be enabled for
// -
// Default: "60"
// Minimum: "0.100000"
chaosmod_long_time_duration "120"

// Time in seconds a normal effect should be enabled for
// -
// Default: "30"
// Minimum: "0.100000"
chaosmod_normal_time_duration "60"

// Time in seconds a short effect should be enabled for
// -
// Default: "15"
// Minimum: "0.100000"
chaosmod_short_time_duration "15"

// How long to wait in seconds between activating effects
// -
// Default: "30"
// Minimum: "0.100000"
chaosmod_time_between_effects "30"
```