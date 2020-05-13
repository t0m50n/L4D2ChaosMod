let effects_tree = {
	text: "All",
	state: {
		opened: true,
		checked: true
	},
	children: [
		{
			text: "Global",
			state: {
				opened: true
			},
			children: [
				{
					text: "Half Gravity",
					start: "chaosmod_cvar sv_gravity 400",
					end: "chaosmod_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Double Gravity",
					start: "chaosmod_cvar sv_gravity 1600",
					end: "chaosmod_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Quarter Gravity",
					start: "chaosmod_cvar sv_gravity 200",
					end: "chaosmod_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Zero Gravity",
					start: "chaosmod_cvar sv_gravity 1",
					end: "chaosmod_cvar sv_gravity 800",
					active_time: "short"
				},
				{
					text: "Shuffle Names",
					start: "sm_rename @all",
					end: "",
					active_time: "none"
				},
				{
					text: "Throw Everyone",
					start: "chaosmod_charge @all 600",
					end: "",
					active_time: "none"
				},
				{
					text: "Dissolve Infected on Death",
					start: "chaosmod_cvar l4d_dissolve_allow 1",
					end: "exec sourcemod/l4d_dissolve_infected",
					active_time: "normal"
				},
				{
					text: "Raining Gascans",
					start: "chaosmod_entityrain @all weapon_gascan 10",
					end: "",
					active_time: "none"
				},
				{
					text: "Ice Rink",
					start: "exec sourcemod/chaosmod/ice_rink_start",
					end: "exec sourcemod/chaosmod/ice_rink_end",
					active_time: "normal"
				},
				{
					text: "Auto Bunnyhop",
					start: "chaosmod_bhop_enabled 1",
					end: "chaosmod_bhop_enabled 0",
					active_time: "long"
				},
				{
					text: "Half Speed",
					start: "chaosmod_timescale 0.5",
					end: "chaosmod_timescale 1",
					active_time: "short"
				},
				{
					text: "Double Speed",
					start: "chaosmod_timescale 2",
					end: "chaosmod_timescale 1",
					active_time: "long"
				},
				{
					text: "Plane Crash",
					start: "chaosmod_planecrash @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "High Ping",
					start: "chaosmod_cvar net_fakelag 500",
					end: "chaosmod_cvar net_fakelag 0",
					active_time: "normal"
				},
				{
					text: "Packet Loss",
					start: "chaosmod_cvar net_fakeloss 50",
					end: "chaosmod_cvar net_fakeloss 0",
					active_time: "normal"
				},
			]
		},
		{
			text: "Survivors",
			state: {
				opened: true
			},
			children: [
				{
					text: "Super Crouch",
					start: "chaosmod_cvar survivor_crouch_speed 400",
					end: "chaosmod_cvar survivor_crouch_speed 75",
					active_time: "normal"
				},
				{
					text: "Infinite Ammo",
					start:"chaosmod_cvar sv_infinite_ammo 1",
					end:"chaosmod_cvar sv_infinite_ammo 0",
					active_time: "normal"
				},
				{
					text: "Bots Keep Shooting",
					start: "chaosmod_cvar sb_open_fire 1",
					end: "chaosmod_cvar sb_open_fire 0",
					active_time: "normal"
				},
				{
					text: "Freeze survivors",
					start: "sm_freeze @survivors 10",
					end: "",
					active_time: "10"
				},
				{
					text: "Blind",
					start: "sm_blind @survivors 255",
					end: "sm_blind @survivors 0",
					active_time: "short"
				},
				{
					text: "Half Blind",
					start: "sm_blind @survivors 210",
					end: "sm_blind @survivors 0",
					active_time: "normal"
				},
				{
					text: "Too Many Pills",
					start: "sm_drug @survivors 1",
					end: "sm_drug @survivors 0",
					active_time: "normal"
				},
				{
					text: "Teleport Back to Saferoom",
					start: "chaosmod_dontrush @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "Big Pants",
					start: "chaosmod_sizeplayer @survivors 2.5",
					end: "chaosmod_sizeplayer @survivors 1",
					active_time: "normal"
				},
				{
					text: "Vomit Survivors",
					start: "chaosmod_vomitplayer @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "1 HP Survivors",
					start: "chaosmod_sethpplayer @survivors 1; chaosmod_settemphpplayer 0",
					end: "chaosmod_sethpplayer @survivors 80; chaosmod_settemphpplayer 0",
					active_time: "normal"
				},
				{
					text: "Give Grenade Launchers",
					start: "sm_giveweapon @survivors grenade_launcher",
					end: "",
					active_time: "none"
				},
				{
					text: "Give Chainsaws",
					start: "sm_giveweapon @survivors chainsaw",
					end: "",
					active_time: "none"
				},
				{
					text: "Give Gnomes",
					start: "sm_giveweapon @survivors gnome",
					end: "",
					active_time: "none"
				},
				{
					text: "Give Defibrillators",
					start: "sm_giveweapon @survivors defibrillator",
					end: "",
					active_time: "none"
				},
				{
					text: "High Weapon Damage",
					start: "exec sourcemod/chaosmod/high_weapon_damage_start.cfg",
					end: "sm_damage_reset",
					active_time: "normal"
				},
				{
					text: "Low Weapon Damage",
					start: "exec sourcemod/chaosmod/low_weapon_damage_start",
					end: "sm_damage_reset",
					active_time: "normal"
				},
				{
					text: "Rapid Fire",
					start: "chaosmod_firerate 1.47",
					end: "chaosmod_firerate 1",
					active_time: "normal"
				},
				{
					text: "Slow Fire",
					start: "chaosmod_firerate 0.68",
					end: "chaosmod_firerate 1",
					active_time: "normal"
				},
				{
					text: "Fast Reload",
					start: "chaosmod_reloadspeed 2.0",
					end: "chaosmod_reloadspeed 1",
					active_time: "normal"
				},
				{
					text: "Slow Reload",
					start: "chaosmod_reloadspeed 0.5",
					end: "chaosmod_reloadspeed 1",
					active_time: "normal"
				},
				{
					text: "High Fall Damage",
					start: "chaosmod_cvar fall_speed_safe 1",
					end: "chaosmod_cvar fall_speed_safe 560",
					active_time: "normal"
				},
				{
					text: "No Fall Damage",
					start: "chaosmod_cvar fall_speed_fatal 9000",
					end: "chaosmod_cvar fall_speed_fatal 720",
					active_time: "normal"
				},
			]
		},
		{
			text: "Infected",
			state: {
				opened: true
			},
			children: [
				{
					text: "Elderly Zombies",
					start: "chaosmod_zspeed 80",
					end: "chaosmod_zspeed 250",
					active_time: "normal"
				},
				{
					text: "Marathon Zombies",
					start: "exec sourcemod/chaosmod/marathon_zombies_start",
					end: "exec sourcemod/chaosmod/marathon_zombies_end",
					active_time: "normal"
				},
				{
					text: "Baby Zombies",
					start: "chaosmod_zsize 0.5",
					end: "chaosmod_zsize 1",
					active_time: "normal"
				},
				{
					text: "Giant Zombies",
					start: "chaosmod_zsize 2",
					end: "chaosmod_zsize 1",
					active_time: "normal"
				},
				{
					text: "Endless Hordes",
					start: "exec sourcemod/chaosmod/endless_hordes_start",
					end: "exec sourcemod/chaosmod/endless_hordes_end",
					active_time: "normal"
				},
				{
					text: "Too Many Specials",
					start: "exec sourcemod/chaosmod/too_many_specials_start",
					end: "exec sourcemod/l4d2_autoIS",
					active_time: "normal"
				},
				{
					text: "Too Many Boomers",
					start: "exec sourcemod/chaosmod/too_many_boomers_start",
					end: "exec sourcemod/l4d2_autoIS",
					active_time: "normal"
				},
				{
					text: "Too Many Spitters",
					start: "exec sourcemod/chaosmod/too_many_spitters_start",
					end: "exec sourcemod/l4d2_autoIS",
					active_time: "normal"
				},
				{
					text: "Taaank",
					start: "exec sourcemod/chaosmod/taank_start",
					end: "exec sourcemod/l4d2_autoIS; sm_slay @tanks",
					active_time: "normal"
				},
				{
					text: "Spawn Clown Horde",
					start: "sm_spawnuncommonhorde clown",
					end: "",
					active_time: "none"
				},
				{
					text: "Spawn Mud Horde",
					start: "sm_spawnuncommonhorde mud",
					end: "",
					active_time: "none"
				},
				{
					text: "Spawn Jimmy Horde",
					start: "sm_spawnuncommonhorde jimmy",
					end: "",
					active_time: "none"
				},
				{
					text: "Raining Witches",
					start: "chaosmod_entityrain @all witch 2",
					end: "",
					active_time: "none"
				},
				{
					text: "Randomise special infected",
					start: "chaosmod_randomisecvars si",
					end: "chaosmod_randomisecvars si 1",
					active_time: "long"
				}
			]
		}
	]
}

