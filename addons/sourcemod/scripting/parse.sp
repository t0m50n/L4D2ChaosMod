ArrayList Parse_KeyValueFile(const char[] path)
{
	char effects_path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, effects_path, sizeof(effects_path), path);
	
	KeyValues kv = new KeyValues("effects");
	kv.SetEscapeSequences(true);
	
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
		
		float active_time = Parse_ActiveTime(buffer);
		if (active_time < 0)
		{
			effect.GetString("name", buffer, sizeof(buffer));
			SetFailState("Invalid active time for effect: %s", buffer);
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

float Parse_ActiveTime(char[] active_time)
{
	StringMapSnapshot durations = g_effect_durations.Snapshot();
	for (int i = 0; i < durations.Length; i++)
	{
		char duration_name[255];
		durations.GetKey(i, duration_name, sizeof(duration_name));
		if (StrEqual(active_time, duration_name, false))
		{
			delete durations;
			ConVar c;
			g_effect_durations.GetValue(duration_name, c);
			return c.FloatValue;
		}
	}
	delete durations;
	
	float f = StringToFloat(active_time);
	if (f < 0.01)
	{
		return -1.0;
	}
	return f;
}