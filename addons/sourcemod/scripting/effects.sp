static StringMap g_effect_durations;

static ConVar g_short_time_duration;
static ConVar g_normal_time_duration;
static ConVar g_long_time_duration;

void Effects_Initialise()
{
	g_short_time_duration = CreateConVar("chaosmod_short_time_duration", "15", "Time in seconds a short effect should be enabled for", FCVAR_NOTIFY, true, 0.1);
	g_normal_time_duration = CreateConVar("chaosmod_normal_time_duration", "30", "Time in seconds a normal effect should be enabled for", FCVAR_NOTIFY, true, 0.1);
	g_long_time_duration = CreateConVar("chaosmod_long_time_duration", "60", "Time in seconds a long effect should be enabled for", FCVAR_NOTIFY, true, 0.1);
	
	g_effect_durations = new StringMap();
	g_effect_durations.SetValue("short", g_short_time_duration);
	g_effect_durations.SetValue("normal", g_normal_time_duration);
	g_effect_durations.SetValue("long", g_long_time_duration);
}

ArrayList Effects_Load(const char[] path)
{
	char effects_path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, effects_path, sizeof(effects_path), path);
	
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
	
	ArrayList effects = new ArrayList();
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
		
		kv.GetString("active_time", buffer, sizeof(buffer));
		
		float active_time = Effects_ParseActiveTime(buffer);
		if (active_time < 0)
		{
			SetFailState("Invalid effect active time");
		}
		effect.SetString("active_time", buffer);
		
		effects.Push(effect);
	} while (kv.GotoNextKey());
	delete kv;

	#if defined DEBUG
		PrintToServer("Number of effects: %d", effects.Length);
		for (int i = 0; i < effects.Length; i++)
		{
			char effect_name[255];
			StringMap effect = view_as<StringMap>(effects.Get(i));
			effect.GetString("name", effect_name, sizeof(effect_name));
			PrintToServer(effect_name);
		}
	#endif
	
	return effects;
}

float Effects_ParseActiveTime(char[] active_time)
{
	StringMapSnapshot durations = g_effect_durations.Snapshot();
	for (int i = 0; i < durations.Length; i++)
	{
		char duration_name[255];
		durations.GetKey(i, duration_name, sizeof(duration_name));
		if (StrEqual(active_time, duration_name))
		{
			CloseHandle(durations);
			ConVar c;
			g_effect_durations.GetValue(duration_name, c);
			return c.FloatValue;
		}
	}
	CloseHandle(durations);
	
	float f = StringToFloat(active_time);
	if (f < 0.01)
	{
		return -1.0;
	}
	return f;
}