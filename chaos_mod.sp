#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "T0M50N"
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "L4D2 Chaos Mod",
	author = PLUGIN_AUTHOR,
	description = "Activates a random effect every 30 seconds.",
	version = PLUGIN_VERSION,
	url = "https://github.com/t0m50n/L4D2ChaosMod"
};

#define EFFECTS_PATH "configs/effects.cfg"

ArrayList g_effects;
ConVar g_time_between_effects;
Handle g_effect_timer;

public void OnPluginStart()
{
	g_time_between_effects = CreateConVar("chaosmod_time_between_effects", "30", _, _, true, 1.0);
	g_time_between_effects.AddChangeHook(OnTimeBetweenEffectsChange);
	
	char effects_path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, effects_path, sizeof(effects_path), EFFECTS_PATH);
	
	KeyValues kv = new KeyValues("effects");
	if (!kv.ImportFromFile(effects_path))
	{
		delete kv;
		SetFailState("Could not open %s", effects_path);
	}
	if (!kv.GotoFirstSubKey())
	{
		delete kv;
		SetFailState("Where the effects at?");
	}
	
	g_effects = new ArrayList();
	do
	{
		StringMap effect = new StringMap();
		char key_value[255];
		
		kv.GetSectionName(key_value, sizeof(key_value));
		effect.SetString("name", key_value, false);
		
		kv.GetString("start", key_value, sizeof(key_value));
		effect.SetString("start", key_value, false);
		
		kv.GetString("end", key_value, sizeof(key_value));
		effect.SetString("end", key_value, false);
		
		effect.SetValue("active_time", kv.GetNum("active_time"));
		
		g_effects.Push(effect);
	} while (kv.GotoNextKey());
	delete kv;

#if defined DEBUG
	PrintToServer("Number of effects: %d", g_effects.Length);
	for (int i = 0; i < g_effects.Length; i++)
	{
		char key_value[255];
		StringMap effect = view_as<StringMap>(g_effects.Get(i));
		effect.GetString("name", key_value, sizeof(key_value));
		PrintToServer(key_value);
	}
#endif

	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_RandomEffect, _, TIMER_REPEAT);
}

public Action Timer_RandomEffect(Handle timer)
{
	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap random_effect = view_as<StringMap>(g_effects.Get(random_effect_i));
	
	char buffer[255];
	random_effect.GetString("name", buffer, sizeof(buffer));
	PrintToServer("Effect %s started.", buffer);
	
	int active_time;
	random_effect.GetValue("active_time", active_time);
	CreateTimer(float(active_time), Timer_StopEffect, random_effect_i);
}

public Action Timer_StopEffect(Handle timer, any effect_i)
{
	StringMap effect = view_as<StringMap>(g_effects.Get(effect_i));
	
	char buffer[255];
	effect.GetString("name", buffer, sizeof(buffer));
	PrintToServer("Effect %s ended.", buffer);
}

public void OnTimeBetweenEffectsChange(ConVar convar, char[] oldValue, char[] newValue)
{
	CloseHandle(g_effect_timer);
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_RandomEffect, _, TIMER_REPEAT);
}