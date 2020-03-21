#define ENTITY_COUNT 10
#define SPAWN_PERIOD_MIN 0.2
#define SPAWN_PERIOD_MAX 1.0
#define RAIN_RADIUS 300.0

public Action Command_EntityRain(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_entityrain <target> <entity name> [count]",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char entity_name[255];
	GetCmdArg(2, entity_name, sizeof(entity_name));

	int entity_count = ENTITY_COUNT;
	if (args > 2)
	{
		char s_count[255];
		GetCmdArg(3, s_count, sizeof(s_count));
		entity_count = StringToInt(s_count);
	}
	
	for (int i = 0; i < target_count; i++)
	{
		EntityRain(target_list[i], entity_name, entity_count);
	}
	
	return Plugin_Handled;
}

void EntityRain(int target, const char[] entity_name, int entity_count)
{
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		return;
	}

	DataPack pack = new DataPack();
	pack.WriteCell(entity_count);
	pack.WriteCell(target);
	pack.WriteString(entity_name);
	CreateTimer(0.1, Timer_RainSingleEntity, pack);
}

public Action Timer_RainSingleEntity(Handle timer, any data)
{
	DataPack pack = view_as<DataPack>(data);

	pack.Reset();
	int entity_count = pack.ReadCell();
	if (entity_count == 0)
	{
		delete pack;
		return Plugin_Stop;
	}
	pack.Reset();
	pack.WriteCell(entity_count - 1);

	int target = pack.ReadCell();
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		delete pack;
		return Plugin_Stop;
	}

	char entity_name[255];
	pack.ReadString(entity_name, sizeof(entity_name));
	int entity = CreateEntityByName(entity_name);
	if (entity < 0)
	{
		delete pack;
		return Plugin_Stop;
	}
	DispatchSpawn(entity);

	float pos[3];
	GetClientAbsOrigin(target, pos);
	pos[2] += 350.0;
	pos[0] += GetRandomFloat(-RAIN_RADIUS, RAIN_RADIUS);
	pos[1] += GetRandomFloat(-RAIN_RADIUS, RAIN_RADIUS);
	TeleportEntity(entity, pos, NULL_VECTOR, NULL_VECTOR);

	CreateTimer(GetRandomFloat(SPAWN_PERIOD_MIN, SPAWN_PERIOD_MAX), Timer_RainSingleEntity, pack);

	return Plugin_Stop;
}