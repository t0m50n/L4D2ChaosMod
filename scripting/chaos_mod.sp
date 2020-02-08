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
#define CVAR_FLAGS FCVAR_NOTIFY

ArrayList g_effects;
Handle g_effect_timer;
StringMap g_effect_active_timers;

ConVar g_time_between_effects;
ConVar g_enabled;

public void OnPluginStart()
{
	CreateConVar("chaosmod_version", PLUGIN_VERSION, " Version of Chaos Mod on this server ", FCVAR_SPONLY|FCVAR_DONTRECORD);
	
	g_enabled = CreateConVar("chaosmod_enabled", "1", "Enable/Disable Chaos Mod", CVAR_FLAGS);
	g_enabled.AddChangeHook(OnCvarEnabledChanged);
	
	g_time_between_effects = CreateConVar("chaosmod_time_between_effects", "15", "How long to wait in seconds between activating effects", CVAR_FLAGS, true, 0.1);
	g_time_between_effects.AddChangeHook(OnCvarTimeBetweenEffectsChanged);
	
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	
	g_effect_active_timers = new StringMap();
	
	LoadEffects();
	StartEffectTimer();
}

void StartEffectTimer()
{
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
}

void LoadEffects()
{
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
		
		kv.GetString("cvar", key_value, sizeof(key_value));
		ConVar cvar = FindConVar(key_value);
		if (cvar == null)
		{
			SetFailState("cvar %s not found", key_value);
		}
		effect.SetValue("cvar", cvar);
		
		effect.SetValue("start", kv.GetFloat("start"));
		effect.SetValue("end", kv.GetFloat("end"));
		effect.SetValue("active_time", kv.GetFloat("active_time"));
		
		g_effects.Push(effect);
	} while (kv.GotoNextKey());
	delete kv;

	#if defined DEBUG
		PrintToChatAll("Number of effects: %d", g_effects.Length);
		for (int i = 0; i < g_effects.Length; i++)
		{
			char key_value[255];
			StringMap effect = view_as<StringMap>(g_effects.Get(i));
			effect.GetString("name", key_value, sizeof(key_value));
			PrintToChatAll(key_value);
		}
	#endif
}

public void OnCvarTimeBetweenEffectsChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	CloseHandle(g_effect_timer);
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
}

public void OnCvarEnabledChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	if (convar.BoolValue)
	{
		StartEffectTimer();
	}
	else
	{
		CloseHandle(g_effect_timer);
	}
}

public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast)
{
	event.BroadcastDisabled = true;
	
	return Plugin_Continue;
}

public Action Timer_StartRandomEffect(Handle timer)
{
	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap random_effect = view_as<StringMap>(g_effects.Get(random_effect_i));
	
	
	ConVar cvar;
	char cvar_name[255];
	Handle active_timer;
	random_effect.GetValue("cvar", cvar);
	cvar.GetName(cvar_name, sizeof(cvar_name));
	
	if (g_effect_active_timers.GetValue(cvar_name, active_timer))
	{
		CloseHandle(active_timer);
	}
	
	float value;
	random_effect.GetValue("start", value);
	cvar.SetFloat(value);
	
	char effect_name[255];
	random_effect.GetString("name", effect_name, sizeof(effect_name));
	PrintToChatAll("Effect %s started.", effect_name);

	random_effect.GetValue("active_time", value);
	active_timer = CreateTimer(value, Timer_StopEffect, random_effect_i);
	g_effect_active_timers.SetValue(cvar_name, active_timer);
}

public Action Timer_StopEffect(Handle timer, any effect_i)
{
	StringMap effect = view_as<StringMap>(g_effects.Get(effect_i));
	
	float end;
	ConVar cvar;
	effect.GetValue("end", end);
	effect.GetValue("cvar", cvar);
	cvar.SetFloat(end);
	
	char effect_name[255];
	effect.GetString("name", effect_name, sizeof(effect_name));
	PrintToChatAll("Effect %s ended.", effect_name);
	
	char cvar_name[255];
	cvar.GetName(cvar_name, sizeof(cvar_name));
	g_effect_active_timers.Remove(cvar_name);
}