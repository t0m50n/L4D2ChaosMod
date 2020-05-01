public void WH_OnMeleeSwing(int client, int weapon, float &speedmodifier)
{
	speedmodifier = g_firerate.FloatValue;
}

public void WH_OnStartThrow(int client, int weapon, L4D2WeaponType weapontype, float &speedmodifier)
{
	speedmodifier = g_firerate.FloatValue;
}

public void WH_OnReadyingThrow(int client, int weapon, L4D2WeaponType weapontype, float &speedmodifier)
{
	speedmodifier = g_firerate.FloatValue;
}

public void WH_OnGetRateOfFire(int client, int weapon, L4D2WeaponType weapontype, float &speedmodifier)
{
	speedmodifier = g_firerate.FloatValue;
}