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
#define P_BAR_LENGTH 30
#define PANEL_UPDATE_RATE 1.0

ArrayList g_effects;
ArrayList g_active_effects;
bool g_new_effect_activated = false;

Handle g_effect_timer;
Handle g_panel_timer;

ConVar g_time_between_effects;
ConVar g_enabled;

public void OnPluginStart()
{
	CreateConVar("chaosmod_version", PLUGIN_VERSION, " Version of Chaos Mod on this server ", FCVAR_SPONLY|FCVAR_DONTRECORD);
	
	g_enabled = CreateConVar("chaosmod_enabled", "1", "Enable/Disable Chaos Mod", FCVAR_NOTIFY);
	g_enabled.AddChangeHook(OnCvarEnabledChanged);
	
	g_time_between_effects = CreateConVar("chaosmod_time_between_effects", "30", "How long to wait in seconds between activating effects", FCVAR_NOTIFY, true, 0.1);
	g_time_between_effects.AddChangeHook(OnCvarTimeBetweenEffectsChanged);
	
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	
	LoadEffects();
	g_active_effects = new ArrayList();
	StartStopGlobalTimers(true);
}

void StartStopGlobalTimers(bool start)
{
	if (start)
	{
		g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
		g_panel_timer = CreateTimer(PANEL_UPDATE_RATE, Timer_UpdatePanel, _, TIMER_REPEAT);
	}
	else
	{
		CloseHandle(g_effect_timer);
		CloseHandle(g_panel_timer);
	}
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
		PrintToServer("Number of effects: %d", g_effects.Length);
		for (int i = 0; i < g_effects.Length; i++)
		{
			char effect_name[255];
			StringMap effect = view_as<StringMap>(g_effects.Get(i));
			effect.GetString("name", effect_name, sizeof(effect_name));
			PrintToServer(effect_name);
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
	StartStopGlobalTimers(false);
	StartStopGlobalTimers(true);
}

public void OnCvarEnabledChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	StartStopGlobalTimers(convar.BoolValue);
}

public int Panel_DoNothing(Menu menu, MenuAction action, int param1, int param2)
{
	
}

public Action Timer_StartRandomEffect(Handle timer)
{
	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap random_effect = view_as<StringMap>(g_effects.Get(random_effect_i));
	StringMap active_effect = new StringMap();
	
	{
		char command[255];
		random_effect.GetString("start", command, sizeof(command));
		ServerCommand(command);
	}
	
	{
		char effect_name[255];
		random_effect.GetString("name", effect_name, sizeof(effect_name));
		active_effect.SetString("effect_name", effect_name);
	}

	{
		float active_time;
		random_effect.GetValue("active_time", active_time);
		active_effect.SetValue("time_left", RoundToFloor(active_time));
		CreateTimer(active_time, Timer_StopEffect, random_effect_i);
	}
	
	g_active_effects.Push(active_effect);
	g_new_effect_activated = true;
}

public Action Timer_StopEffect(Handle timer, any effect_i)
{
	StringMap effect = view_as<StringMap>(g_effects.Get(effect_i));
	
	char buffer[255];
	effect.GetString("end", buffer, sizeof(buffer));
	ServerCommand(buffer);
}

public Action Timer_UpdatePanel(Handle timer, any unused)
{
	static int time_until_next_effect = 0;
	
	if (g_new_effect_activated)
	{
		g_new_effect_activated = false;
		time_until_next_effect = g_time_between_effects.IntValue;
	}
	
	Panel p = new Panel();
	
	p.SetTitle("Chaos Mod");
	
	{
		char next_effect_pbar[255];
		next_effect_pbar[P_BAR_LENGTH] = 0;
		int pbar_fullness = RoundToFloor((time_until_next_effect / g_time_between_effects.FloatValue) * P_BAR_LENGTH);
		for (int i = 0; i < P_BAR_LENGTH; i++)
		{
			if (i < pbar_fullness)
			{
				next_effect_pbar[i] = '#';
			}
			else
			{
				next_effect_pbar[i] = '_';
			}
		}
		p.DrawText(next_effect_pbar);
	}
	
	for (int i = g_active_effects.Length - 1; i >= 0; i--)
	{
		StringMap active_effect = view_as<StringMap>(g_active_effects.Get(i));
		
		int time_left;
		active_effect.GetValue("time_left", time_left);
		
		char effect_name[255];
		active_effect.GetString("effect_name", effect_name, sizeof(effect_name));
		
		char panel_text[255];
		Format(panel_text, sizeof(panel_text), "%s (%d)", effect_name, time_left);
		p.DrawText(panel_text);
		
		if (time_left == 1)
		{
			g_active_effects.Erase(i);
			CloseHandle(active_effect);
			continue;
		}
		active_effect.SetValue("time_left", time_left - 1);
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			p.Send(i, Panel_DoNothing, RoundToFloor(PANEL_UPDATE_RATE) + 1);
		}
	}
	
	CloseHandle(p);
	
	if (time_until_next_effect > 0)
	{
		time_until_next_effect--;
	}
}