/*
Code adapted from the following plugin:

*	Name	:	[L4D & L4D2] Plane Crash
*	Author	:	SilverShot
*	Descrp	:	Creates the Dead Air Plane Crash on any map.
*	Link	:	https://forums.alliedmods.net/showthread.php?t=181517
*	Plugins	:	https://sourcemod.net/plugins.php?exact=exact&sortby=title&search=1&author=Silvers

*/
#define MAX_ENTITIES 		25

#define MODEL_PLANE01		"models/hybridphysx/precrash_airliner.mdl"
#define MODEL_PLANE02		"models/hybridphysx/airliner_fuselage_secondary_1.mdl"
#define MODEL_PLANE03		"models/hybridphysx/airliner_fuselage_secondary_2.mdl"
#define MODEL_PLANE04		"models/hybridphysx/airliner_fuselage_secondary_3.mdl"
#define MODEL_PLANE05		"models/hybridphysx/airliner_fuselage_secondary_4.mdl"
#define MODEL_PLANE06		"models/hybridphysx/airliner_left_wing_secondary.mdl"
#define MODEL_PLANE07		"models/hybridphysx/airliner_right_wing_secondary_1.mdl"
#define MODEL_PLANE08		"models/hybridphysx/airliner_right_wing_secondary_2.mdl"
#define MODEL_PLANE09		"models/hybridphysx/airliner_tail_secondary.mdl"
#define MODEL_PLANE10		"models/hybridphysx/airliner_primary_debris_4.mdl"
#define MODEL_PLANE11		"models/hybridphysx/airliner_primary_debris_1.mdl"
#define MODEL_PLANE12		"models/hybridphysx/airliner_primary_debris_2.mdl"
#define MODEL_PLANE13		"models/hybridphysx/airliner_primary_debris_3.mdl"
#define MODEL_PLANE14		"models/hybridphysx/airliner_fire_emit1.mdl"
#define MODEL_PLANE15		"models/hybridphysx/airliner_fire_emit2.mdl"
#define MODEL_PLANE16		"models/hybridphysx/airliner_sparks_emit.mdl"
#define MODEL_PLANE17		"models/hybridphysx/airliner_endstate_vcollide_dummy.mdl"
#define MODEL_BOUNDING		"models/props/cs_militia/silo_01.mdl"
#define SOUND_CRASH			"animation/airport_rough_crash_seq.wav"

int g_iEntities[MAX_ENTITIES];

public Action Command_PlaneCrash(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: chaosmod_planecrash <#userid|name>",
			1, target_list, MAXPLAYERS);
	
	if (target_count <= 0)
	{
		return Plugin_Handled;
	}

	CreateCrash(target_list[0]);

	return Plugin_Handled;
}

public void Effect_PlaneCrash_OnMapStart()
{
	PrecacheModel(MODEL_PLANE01, true);
	PrecacheModel(MODEL_PLANE02, true);
	PrecacheModel(MODEL_PLANE03, true);
	PrecacheModel(MODEL_PLANE04, true);
	PrecacheModel(MODEL_PLANE05, true);
	PrecacheModel(MODEL_PLANE06, true);
	PrecacheModel(MODEL_PLANE07, true);
	PrecacheModel(MODEL_PLANE08, true);
	PrecacheModel(MODEL_PLANE09, true);
	PrecacheModel(MODEL_PLANE10, true);
	PrecacheModel(MODEL_PLANE11, true);
	PrecacheModel(MODEL_PLANE12, true);
	PrecacheModel(MODEL_PLANE13, true);
	PrecacheModel(MODEL_PLANE14, true);
	PrecacheModel(MODEL_PLANE15, true);
	PrecacheModel(MODEL_PLANE16, true);
	PrecacheModel(MODEL_PLANE17, true);
	PrecacheModel(MODEL_BOUNDING, true);

	PrecacheSound(SOUND_CRASH, true);

	// Pre-cache env_shake -_- WTF
	int shake  = CreateEntityByName("env_shake");
	if( shake != -1 )
	{
		DispatchKeyValue(shake, "spawnflags", "8");
		DispatchKeyValue(shake, "amplitude", "16.0");
		DispatchKeyValue(shake, "frequency", "1.5");
		DispatchKeyValue(shake, "duration", "0.9");
		DispatchKeyValue(shake, "radius", "50");
		TeleportEntity(shake, view_as<float>({ 0.0, 0.0, -1000.0 }), NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(shake);
		ActivateEntity(shake);
		AcceptEntityInput(shake, "Enable");

		AcceptEntityInput(shake, "StartShake");
		RemoveEdict(shake);
	}
}

public void Effect_PlaneCrash_OnMapEnd()
{
	DeletePrevCrash();
}

bool IsValidEntRef(int entity)
{
	return entity && EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE;
}

void DeletePrevCrash()
{
	int entity = g_iEntities[0];
	g_iEntities[0] = 0;
	if( IsValidEntRef(entity) )
	{
		AcceptEntityInput(entity, "CancelPending");
		AcceptEntityInput(entity, "Disable");
		SetVariantString("OnUser1 !self:Kill::1.0:-1");
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
	}

	entity = g_iEntities[1];
	g_iEntities[1] = 0;
	if( IsValidEntRef(entity) )
	{
		SetVariantInt(0);
		AcceptEntityInput(entity, "Volume");
		AcceptEntityInput(entity, "Kill");
	}

	for( int i = 1; i < MAX_ENTITIES; i++ )
	{
		if( IsValidEntRef(g_iEntities[i]) )
			AcceptEntityInput(g_iEntities[i], "Kill");
		g_iEntities[i] = 0;
	}
}

void CreateCrash(int client)
{
	DeletePrevCrash();

	float vPos[3], vAng[3];

	GetClientAbsOrigin(client, vPos);
	GetClientEyeAngles(client, vAng);

	CreatePlaneCrash(vPos, vAng);

	if(client)
	{
		AcceptEntityInput(g_iEntities[0], "Trigger");
	}
}

void CreatePlaneCrash(float vPos[3], float vAng[3])
{
	float vLoc[3];

	vLoc = vPos;

	float p, x, y;

	if( vAng[1] <= -90.0 )
	{
		p = (vAng[1] * -1.0) * 100 / 90;
		x = -1500 * (200 - p) / 100;
		y = -1500 * (100 - p) / 100;
	}
	else if( vAng[1] <= 0.0 )
	{
		p = (vAng[1] * -1.0) * 100 / 90;
		x = -1500 * p / 100;
		y = -1500 * (100 - p) / 100;
	}
	else if( vAng[1] <= 90.0 )
	{
		p = vAng[1] * 100 / 90;
		x = 1500 * p / 100;
		y = -1500 * (100 - p) / 100;
	}
	else if( vAng[1] <= 180.0 )
	{
		p = vAng[1] * 100 / 90;
		x = 1500 * (200 - p) / 100;
		y = -1500 * (100 - p) / 100;
	}

	vLoc[0] += x;
	vLoc[1] += y;
	vLoc[2] -= 50.0;
	vAng[0] = 0.0;
	vAng[1] += 30;
	vAng[2] = 0.0;

	vPos = vLoc;

	int count;
	int entity;

	entity = CreateEntityByName("logic_relay");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_trigger");
	DispatchKeyValue(entity, "spawnflags", "1");
	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
	g_iEntities[count++] = entity;

	SetVariantString("OnTrigger silver_planecrash_collision:FireUser2::27:-1");
	AcceptEntityInput(entity, "AddOutput");

	SetVariantString("OnTrigger silver_plane_crash_sound:PlaySound::0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_crash_shake:StartShake::20.5:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_crash_shake:StartShake::23:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_crash_shake:StartShake::24:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_crash_shake:StartShake::26:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_crash_shake:Kill::30:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_precrash:SetAnimation:approach:0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_precrash:Kill::15:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_precrash:Kill::16:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_plane_precrash:TurnOn::0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash:SetAnimation:idleOuttaMap:0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash:SetAnimation:boom:14.95:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash:TurnOn::14:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_tailsection:SetAnimation:boom:14.95:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_tailsection:SetAnimation:idleOuttaMap:0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_tailsection:TurnOn::14:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_engine:SetAnimation:boom:14.95:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_engine:SetAnimation:idleOuttaMap:0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_engine:TurnOn::14:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_wing:SetAnimation:idleOuttaMap:0:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_wing:SetAnimation:boom:14.95:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_wing:TurnOn::14:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_tail:Enable::15:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_tail:Kill::27:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_engine:Enable::15:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_engine:Kill::27:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_wing:Enable::15:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_hurt_wing:Kill::27:-1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnTrigger silver_planecrash_emitters:SetAnimation:boom:14.95:-1");
	AcceptEntityInput(entity, "AddOutput");
	DispatchSpawn(entity);


	entity = CreateEntityByName("ambient_generic");
	DispatchKeyValue(entity, "targetname", "silver_plane_crash_sound");
	DispatchKeyValue(entity, "volume", "2");
	DispatchKeyValue(entity, "spawnflags", "49");
	DispatchKeyValue(entity, "radius", "3250");
	DispatchKeyValue(entity, "pitchstart", "100");
	DispatchKeyValue(entity, "pitch", "100");
	DispatchKeyValue(entity, "message", "airport.planecrash");
	DispatchSpawn(entity);
	ActivateEntity(entity);
	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("env_shake");
	DispatchKeyValue(entity, "targetname", "silver_plane_crash_shake");
	DispatchKeyValue(entity, "spawnflags", "1");
	DispatchKeyValue(entity, "duration", "4");
	DispatchKeyValue(entity, "amplitude", "4");
	DispatchKeyValue(entity, "frequency", "100");
	DispatchKeyValue(entity, "radius", "3117");
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, NULL_VECTOR, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_plane_precrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE01);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE02);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE03);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE04);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE05);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE06);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE07);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE08);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE09);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE10);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_tailsection");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE11);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_engine");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE12);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_wing");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "disableshadows", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE13);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_emitters");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE14);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_emitters");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE15);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_emitters");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "0");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "model", MODEL_PLANE16);
	DispatchSpawn(entity);
	TeleportEntity(entity, vLoc, vAng, NULL_VECTOR);
	g_iEntities[count++] = EntIndexToEntRef(entity);


	vPos = vLoc;
	entity = CreateEntityByName("prop_dynamic");
	DispatchKeyValue(entity, "targetname", "silver_planecrash_collision");
	DispatchKeyValue(entity, "spawnflags", "0");
	DispatchKeyValue(entity, "solid", "6");
	DispatchKeyValue(entity, "StartDisabled", "1");
	DispatchKeyValue(entity, "RandomAnimation", "0");
	DispatchKeyValue(entity, "model", MODEL_PLANE17);
	DispatchSpawn(entity);
	vPos[2] += 9999.9;
	TeleportEntity(entity, vPos, vAng, NULL_VECTOR);
	vPos[2] -= 9999.9;
	g_iEntities[count++] = EntIndexToEntRef(entity);
}