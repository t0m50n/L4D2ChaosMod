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

ConVar g_time_between_effects;
ConVar g_enabled;

ArrayList g_active_effects;

public void OnPluginStart()
{
	CreateConVar("chaosmod_version", PLUGIN_VERSION, " Version of Chaos Mod on this server ", FCVAR_SPONLY|FCVAR_DONTRECORD);
	
	g_enabled = CreateConVar("chaosmod_enabled", "1", "Enable/Disable Chaos Mod", CVAR_FLAGS);
	g_enabled.AddChangeHook(OnCvarEnabledChanged);
	
	g_time_between_effects = CreateConVar("chaosmod_time_between_effects", "15", "How long to wait in seconds between activating effects", CVAR_FLAGS, true, 0.1);
	g_time_between_effects.AddChangeHook(OnCvarTimeBetweenEffectsChanged);
	
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	
	LoadEffects();
	g_active_effects = new ArrayList();
	StartEffectTimer();
	CreateTimer(1.0, Timer_UpdatePanel, _, TIMER_REPEAT);
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
		char buffer[255];
		
		kv.GetSectionName(buffer, sizeof(buffer));
		effect.SetString("name", buffer);
		
		kv.GetString("start", buffer, sizeof(buffer));
		effect.SetString("start", buffer);
		
		kv.GetString("end", buffer, sizeof(buffer));
		effect.SetString("end", buffer);
		
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

public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast)
{
	// event.BroadcastDisabled = true;
	
	return Plugin_Handled;
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

public int Panel_DoNothing(Menu menu, MenuAction action, int param1, int param2)
{
	
}

public Action Timer_StartRandomEffect(Handle timer)
{
	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap random_effect = view_as<StringMap>(g_effects.Get(random_effect_i));
	
	char command[255];
	random_effect.GetString("start", command, sizeof(command));
	ServerCommand(command);
	
	char effect_name[255];
	random_effect.GetString("name", effect_name, sizeof(effect_name));
	PrintToChatAll("Effect %s started.", effect_name);

	float value;
	random_effect.GetValue("active_time", value);
	CreateTimer(value, Timer_StopEffect, random_effect_i);
	
	StringMap active_effect = new StringMap();
	active_effect.SetValue("time_left", RoundToFloor(value));
	active_effect.SetString("effect_name", effect_name);
	g_active_effects.Push(active_effect);
}

public Action Timer_StopEffect(Handle timer, any effect_i)
{
	StringMap effect = view_as<StringMap>(g_effects.Get(effect_i));
	
	char buffer[255];
	effect.GetString("end", buffer, sizeof(buffer));
	ServerCommand(buffer);
	
	effect.GetString("name", buffer, sizeof(buffer));
	PrintToChatAll("Effect %s ended.", buffer);
}

public Action Timer_UpdatePanel(Handle timer, any unused)
{
	Panel p = new Panel();
	p.SetTitle("Chaos Mod");
	p.DrawText("Effect Name:\t\tTime Left:");
	
	for (int i = g_active_effects.Length - 1; i >= 0; i--)
	{ 
		StringMap active_effect = view_as<StringMap>(g_active_effects.Get(i));
		
		int time_left;
		active_effect.GetValue("time_left", time_left);
		
		char effect_name[255];
		active_effect.GetString("effect_name", effect_name, sizeof(effect_name));
		
		char panel_text[255];
		Format(panel_text, sizeof(panel_text), "%s\t\t%d", effect_name, time_left);
		p.DrawText(panel_text);
		
		time_left--;
		if (time_left == 0)
		{
			g_active_effects.Erase(i);
			CloseHandle(active_effect);
			continue;
		}
		active_effect.SetValue("time_left", time_left);
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			p.Send(i, Panel_DoNothing, 5);
		}
	}
	
	CloseHandle(p);
}