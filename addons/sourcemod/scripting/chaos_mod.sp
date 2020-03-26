#pragma semicolon 1
#pragma newdecls required

#define DEBUG

#define PLUGIN_AUTHOR "T0M50N"
#define PLUGIN_VERSION "1.0.0"

#include <sourcemod>
#include <sdktools>

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
StringMap g_effect_durations;

Handle g_effect_timer = INVALID_HANDLE;
Handle g_panel_timer = INVALID_HANDLE;

ConVar g_enabled;
ConVar g_time_between_effects;
ConVar g_short_time_duration;
ConVar g_normal_time_duration;
ConVar g_long_time_duration;

bool g_round_started = false;

#include "parse.sp"

public void OnPluginStart()
{
	CreateConVar("chaosmod_version", PLUGIN_VERSION, " Version of Chaos Mod on this server ", FCVAR_SPONLY|FCVAR_DONTRECORD);
	g_enabled = CreateConVar("chaosmod_enabled", "1", "Enable/Disable Chaos Mod", FCVAR_NOTIFY);
	g_time_between_effects = CreateConVar("chaosmod_time_between_effects", "30", "How long to wait in seconds between activating effects", FCVAR_NOTIFY, true, 0.1);
	g_short_time_duration = CreateConVar("chaosmod_short_time_duration", "15", "A short effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);
	g_normal_time_duration = CreateConVar("chaosmod_normal_time_duration", "60", "A normal effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);
	g_long_time_duration = CreateConVar("chaosmod_long_time_duration", "120", "A long effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);

	g_active_effects = new ArrayList();
	g_effect_durations = new StringMap();
	g_effect_durations.SetValue("none", g_normal_time_duration);
	g_effect_durations.SetValue("short", g_short_time_duration);
	g_effect_durations.SetValue("normal", g_normal_time_duration);
	g_effect_durations.SetValue("long", g_long_time_duration);
	g_effects = Parse_KeyValueFile(EFFECTS_PATH);

	g_time_between_effects.AddChangeHook(Cvar_TimeBetweenEffectsChanged);
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
	g_panel_timer = CreateTimer(PANEL_UPDATE_RATE, Timer_UpdatePanel, _, TIMER_REPEAT);
	
	AutoExecConfig(true);
	
	#if defined DEBUG
		RegAdminCmd("chaosmod_effect", Command_Start_Effect, ADMFLAG_GENERIC, "Activates a specific effect");
	#endif
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	g_round_started = true;

	return Plugin_Continue;
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	g_round_started = false;

	return Plugin_Continue;
}

public Action Event_Cvar(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_enabled.BoolValue)
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

public void Cvar_TimeBetweenEffectsChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	if (!g_enabled.BoolValue)
	{
		return;
	}
	delete g_effect_timer;
	delete g_panel_timer;
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
	g_panel_timer = CreateTimer(PANEL_UPDATE_RATE, Timer_UpdatePanel, _, TIMER_REPEAT);
}

public int Panel_DoNothing(Menu menu, MenuAction action, int param1, int param2) {}

public Action Command_Start_Effect(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "Usage: chaosmod_effect <effect_name>");
		return Plugin_Handled;
	}
 
	char name[255];
	GetCmdArg(1, name, sizeof(name));
	
	for (int i = 0; i < g_effects.Length; i++)
	{
		StringMap effect = view_as<StringMap>(g_effects.Get(i));
		char name_other[255];
		effect.GetString("name", name_other, sizeof(name_other));
		if (StrEqual(name, name_other, false))
		{
			StartEffect(effect);
			return Plugin_Handled;
		}
	}
	
	ReplyToCommand(client, "Effect not found");
	return Plugin_Handled;
}

void StartEffect(StringMap effect)
{
	StringMap active_effect = new StringMap();
	char buffer[255];
	
	effect.GetString("start", buffer, sizeof(buffer));
	ServerCommand(buffer);
	
	effect.GetString("name", buffer, sizeof(buffer));
	active_effect.SetString("effect_name", buffer);

	float f_active_time;
	effect.GetString("active_time", buffer, sizeof(buffer));
	f_active_time = Parse_ActiveTime(buffer);
	active_effect.SetValue("time_left", RoundToFloor(f_active_time));
	active_effect.SetValue("is_timed_effect", !StrEqual(buffer, "none", false));
	
	CreateTimer(f_active_time, Timer_StopEffect, effect);
	g_active_effects.Push(active_effect);
}

public Action Timer_StartRandomEffect(Handle timer)
{
	if (!g_enabled.BoolValue || !g_round_started)
	{
		return Plugin_Handled;
	}

	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap effect = view_as<StringMap>(g_effects.Get(random_effect_i));
	
	StartEffect(effect);

	return Plugin_Handled;
}

public Action Timer_StopEffect(Handle timer, StringMap effect)
{
	if (!g_enabled.BoolValue)
	{
		return Plugin_Handled;
	}

	char buffer[255];
	effect.GetString("end", buffer, sizeof(buffer));
	ServerCommand(buffer);

	return Plugin_Handled;
}

public Action Timer_UpdatePanel(Handle timer, any unused)
{
	static int no_active_effects = 0;
	static int time_until_next_effect = -1;

	if (!g_enabled.BoolValue)
	{
		return Plugin_Handled;
	}

	if (no_active_effects != g_active_effects.Length || time_until_next_effect < 0)
	{
		time_until_next_effect = g_time_between_effects.IntValue;
	}
	
	Panel p = new Panel();
	
	p.SetTitle("Chaos Mod");
	
	{
		char next_effect_pbar[P_BAR_LENGTH + 1];
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
		
		if (time_until_next_effect > 0)
		{
			time_until_next_effect--;
		}
	}
	
	for (int i = g_active_effects.Length - 1; i >= 0; i--)
	{
		StringMap active_effect = view_as<StringMap>(g_active_effects.Get(i));
		
		int time_left;
		active_effect.GetValue("time_left", time_left);
		
		
		char effect_name[255];
		active_effect.GetString("effect_name", effect_name, sizeof(effect_name));
		
		char panel_text[255];
		bool is_timed_effect;
		active_effect.GetValue("is_timed_effect", is_timed_effect);
		if (is_timed_effect)
		{
			Format(panel_text, sizeof(panel_text), "%s (%d)", effect_name, time_left);
		}	
		else
		{
			Format(panel_text, sizeof(panel_text), "%s", effect_name);
		}
		p.DrawText(panel_text);
		
		if (time_left == 1)
		{
			g_active_effects.Erase(i);
			delete active_effect;
			continue;
		}
		active_effect.SetValue("time_left", time_left - 1);
	}
	
	no_active_effects = g_active_effects.Length;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			p.Send(i, Panel_DoNothing, RoundToFloor(PANEL_UPDATE_RATE) + 1);
		}
	}
	
	delete p;

	return Plugin_Handled;
}