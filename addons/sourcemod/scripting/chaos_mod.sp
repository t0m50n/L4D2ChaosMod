#pragma semicolon 1
#pragma newdecls required

#define DEBUG

#define PLUGIN_AUTHOR "T0M50N"
#define PLUGIN_VERSION "1.2.1"

#include <sourcemod>
#include <sdktools>

/* Make the admin menu plugin optional */
#undef REQUIRE_PLUGIN
#include <adminmenu>

public Plugin myinfo = 
{
	name = "L4D2 Chaos Mod",
	author = PLUGIN_AUTHOR,
	description = "Activates a random effect every 30 seconds.",
	version = PLUGIN_VERSION,
	url = "https://github.com/t0m50n/L4D2ChaosMod"
};

#define EFFECTS_PATH "configs/effects.cfg"
#define P_BAR_LENGTH 36
#define PANEL_UPDATE_RATE 1.0
#define VOTE_DURATION 20
#define EFFECT_CHOOSE_ATTEMPTS 20

ArrayList g_effects;
ArrayList g_active_effects;
StringMap g_EFFECT_DURATIONS;

Handle g_effect_timer = INVALID_HANDLE;
Handle g_panel_timer = INVALID_HANDLE;

TopMenu g_admin_menu = null;

ConVar g_enabled;
ConVar g_time_between_effects;
ConVar g_short_time_duration;
ConVar g_normal_time_duration;
ConVar g_long_time_duration;

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
	g_EFFECT_DURATIONS = new StringMap();
	g_EFFECT_DURATIONS.SetValue("none", g_normal_time_duration);
	g_EFFECT_DURATIONS.SetValue("short", g_short_time_duration);
	g_EFFECT_DURATIONS.SetValue("normal", g_normal_time_duration);
	g_EFFECT_DURATIONS.SetValue("long", g_long_time_duration);
	g_effects = Parse_KeyValueFile(EFFECTS_PATH);

	RegAdminCmd("chaosmod_vote", Command_Vote, ADMFLAG_GENERIC, "Starts vote to enable/disable chaosmod");
	RegAdminCmd("chaosmod_refresh", Command_Refresh, ADMFLAG_GENERIC, "Reloads effects from config");
	g_time_between_effects.AddChangeHook(Cvar_TimeBetweenEffectsChanged);
	g_enabled.AddChangeHook(Cvar_EnabledChanged);
	HookEvent("server_cvar", Event_Cvar, EventHookMode_Pre);
	g_effect_timer = CreateTimer(g_time_between_effects.FloatValue, Timer_StartRandomEffect, _, TIMER_REPEAT);
	g_panel_timer = CreateTimer(PANEL_UPDATE_RATE, Timer_UpdatePanel, _, TIMER_REPEAT);

	/* See if the menu plugin is already ready */
	TopMenu topmenu;
	if (LibraryExists("adminmenu") && ((topmenu = GetAdminTopMenu()) != null))
	{
		/* If so, manually fire the callback */
		OnAdminMenuReady(topmenu);
	}
	
	AutoExecConfig(true);
	
	#if defined DEBUG
		RegAdminCmd("chaosmod_effect", Command_Start_Effect, ADMFLAG_GENERIC, "Activates a specific effect");
	#endif
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "adminmenu", false))
	{
		g_admin_menu = null;
	}
}

public void OnAdminMenuReady(Handle aTopMenu)
{
	TopMenu topmenu = TopMenu.FromHandle(aTopMenu);
 
	/* Block us from being called twice */
	if (topmenu == g_admin_menu)
	{
		return;
	}
 
	g_admin_menu = topmenu;
 
	/* If the category is third party, it will have its own unique name. */
	TopMenuObject voting_commands = FindTopMenuCategory(g_admin_menu, ADMINMENU_VOTINGCOMMANDS);
 
	if (voting_commands == INVALID_TOPMENUOBJECT)
	{
		/* Error! */
		return;
	}

	g_admin_menu.AddItem("chaosmod_vote", AdminMenu_ChaosModVote, voting_commands, "chaosmod_vote", ADMFLAG_VOTE);
}

public void AdminMenu_ChaosModVote(TopMenu topmenu, 
			TopMenuAction action,
			TopMenuObject object_id,
			int param,
			char[] buffer,
			int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		Format(buffer, maxlength, "Chaos Mod Vote");
	}
	else if (action == TopMenuAction_SelectOption)
	{
		Command_Vote(param, 0);
	}
	else if (action == TopMenuAction_DrawOption)
	{	
		/* disable this option if a vote is already running */
		buffer[0] = !IsNewVoteAllowed() ? ITEMDRAW_IGNORE : ITEMDRAW_DEFAULT;
	}
}

/*
	Blocks cvar changes being announced while chaosmod is enabled
*/
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

public void Cvar_EnabledChanged(ConVar convar, char[] oldValue, char[] newValue)
{
	if (!g_enabled.BoolValue)
	{
		// Disable all currently active effects
		for (int i = 0; i < g_active_effects.Length; i++)
		{
			StringMap active_effect = view_as<StringMap>(g_active_effects.Get(i));
			StopEffect(active_effect);
			delete active_effect;
		}
		g_active_effects.Clear();
	}
}

public int Panel_DoNothing(Menu menu, MenuAction action, int param1, int param2) {}

public Action Command_Vote(int client, int args)
{
	if (IsVoteInProgress())
	{
		ReplyToCommand(client, "[SM] Vote in Progress");
		return Plugin_Handled;
	}

	LogAction(client, -1, "\"%L\" initiated a chaosmod vote.", client);
	ShowActivity2(client, "[SM] ", "Initiate Chaos Mod Vote");

	Menu menu = new Menu(Vote_Callback);
	menu.SetTitle("%s Chaos Mod?", g_enabled.BoolValue ? "Disable": "Enable");
	menu.AddItem(g_enabled.BoolValue ? "0": "1", "Yes");
	menu.AddItem("no", "No");
	menu.ExitButton = false;
	menu.DisplayVoteToAll(VOTE_DURATION);

	return Plugin_Handled;
}

public int Vote_Callback(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menu;
	}
	else if (action == MenuAction_VoteEnd)
	{
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			char enable[64];
			menu.GetItem(param1, enable, sizeof(enable));
			g_enabled.SetString(enable);
		}
	}
}

public Action Command_Refresh(int client, int args)
{
	delete g_effects;
	g_effects = Parse_KeyValueFile(EFFECTS_PATH);
	return Plugin_Handled;
}

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
	active_effect.SetString("name", buffer);

	effect.GetString("end", buffer, sizeof(buffer));
	active_effect.SetString("end", buffer);

	float f_active_time;
	effect.GetString("active_time", buffer, sizeof(buffer));
	f_active_time = Parse_ActiveTime(buffer);
	active_effect.SetValue("time_left", RoundToFloor(f_active_time));
	active_effect.SetValue("is_timed_effect", !StrEqual(buffer, "none", false));
	
	g_active_effects.Push(active_effect);
}

void StopEffect(StringMap active_effect)
{
	char buffer[255];
	active_effect.GetString("end", buffer, sizeof(buffer));
	ServerCommand(buffer);
}

StringMap AttemptChooseRandomEffect()
{
	int random_effect_i = GetRandomInt(0, g_effects.Length - 1);
	StringMap effect = view_as<StringMap>(g_effects.Get(random_effect_i));

	// Check if effect can be used on current map
	ArrayList maps;
	if (effect.GetValue("disable_on_maps", maps))
	{
		char current_map[64];
		GetCurrentMap(current_map, sizeof(current_map));

		for (int i = 0; i < maps.Length; i++)
		{
			char map[64];
			maps.GetString(i, map, sizeof(map));
			if (StrEqual(current_map, map))
			{
				return view_as<StringMap>(INVALID_HANDLE);
			}
		}
	}

	return effect;
}

public Action Timer_StartRandomEffect(Handle timer)
{
	if (!g_enabled.BoolValue)
	{
		return Plugin_Handled;
	}

	StringMap effect;
	int i = 0;
	while (i < EFFECT_CHOOSE_ATTEMPTS)
	{
		effect = AttemptChooseRandomEffect();
		if (effect != INVALID_HANDLE)
		{
			break;
		}
		i++;
	}

	if (i == EFFECT_CHOOSE_ATTEMPTS)
	{
		SetFailState("Could not pick random effect meeting requirements.");
	}
	
	StartEffect(effect);

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
	
	DrawProgressBarPanelText(p, 1 - (time_until_next_effect / g_time_between_effects.FloatValue));
	if (time_until_next_effect > 0)
	{
		time_until_next_effect--;
	}
	
	for (int i = g_active_effects.Length - 1; i >= 0; i--)
	{
		StringMap active_effect = view_as<StringMap>(g_active_effects.Get(i));
		
		DrawActiveEffectPanelText(p, active_effect);

		int time_left;
		active_effect.GetValue("time_left", time_left);

		if (time_left == 0)
		{
			g_active_effects.Erase(i);
			StopEffect(active_effect);
			delete active_effect;
			continue;
		}
		active_effect.SetValue("time_left", time_left - 1);
	}
	no_active_effects = g_active_effects.Length;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		// If a menu is open then don't show the panel
		if (IsClientInGame(i) && (GetClientMenu(i) == MenuSource_RawPanel || GetClientMenu(i) == MenuSource_None))
		{
			p.Send(i, Panel_DoNothing, RoundToFloor(PANEL_UPDATE_RATE) + 1);
		}
	}
	
	delete p;

	return Plugin_Handled;
}

void DrawProgressBarPanelText(Panel panel, float fullness)
{
	char pbar[P_BAR_LENGTH + 1];
	pbar[P_BAR_LENGTH] = 0;
	int pbar_fullness = RoundToNearest(fullness * P_BAR_LENGTH);
	for (int i = 0; i < P_BAR_LENGTH; i++)
	{
		if (i < pbar_fullness)
		{
			pbar[i] = '#';
		}
		else
		{
			pbar[i] = '_';
		}
	}
	panel.DrawText(pbar);
}

void DrawActiveEffectPanelText(Panel panel, StringMap active_effect)
{
	int time_left;
	active_effect.GetValue("time_left", time_left);
	
	char effect_name[255];
	active_effect.GetString("name", effect_name, sizeof(effect_name));
	
	bool is_timed_effect;
	active_effect.GetValue("is_timed_effect", is_timed_effect);

	char panel_text[255];
	if (is_timed_effect)
	{
		Format(panel_text, sizeof(panel_text), "%s (%d)", effect_name, time_left);
	}	
	else
	{
		Format(panel_text, sizeof(panel_text), "%s", effect_name);
	}

	panel.DrawText(panel_text);
}