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
					start: "sm_cvarsilent sv_gravity 400",
					end: "sm_cvarsilent sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Double Gravity",
					start: "sm_cvarsilent sv_gravity 1600",
					end: "sm_cvarsilent sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Quarter Gravity",
					start: "sm_cvarsilent sv_gravity 200",
					end: "sm_cvarsilent sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Zero Gravity",
					start: "sm_cvarsilent sv_gravity 1",
					end: "sm_cvarsilent sv_gravity 800",
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
					start: "sm_charge @all 600",
					end: "",
					active_time: "none"
				},
				{
					text: "Dissolve Infected on Death",
					start: "sm_cvarsilent l4d_dissolve_allow 1",
					end: "exec sourcemod/l4d_dissolve_infected",
					active_time: "normal"
				},
				{
					text: "Raining Gascans",
					start: "sm_entityrain @all weapon_gascan 10",
					end: "",
					active_time: "none"
				},
				{
					text: "Ice Rink",
					start: "exec sourcemod/chaosmod/ice_rink_start",
					end: "exec sourcemod/chaosmod/ice_rink_end",
					active_time: "normal"
				}
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
					start: "sm_cvarsilent survivor_crouch_speed 400",
					end: "sm_cvarsilent survivor_crouch_speed 75",
					active_time: "short"
				},
				{
					text: "Infinite Ammo",
					start:"sm_cvarsilent sv_infinite_ammo 1",
					end:"sm_cvarsilent sv_infinite_ammo 0",
					active_time: "normal"
				},
				{
					text: "Bots Keep Shooting",
					start: "sm_cvarsilent sb_open_fire 1",
					end: "sm_cvarsilent sb_open_fire 0",
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
					start: "sm_dontrush @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "Big Pants",
					start: "sm_sizeplayer @survivors 2.5",
					end: "sm_sizeplayer @survivors 1",
					active_time: "normal"
				},
				{
					text: "Vomit Survivors",
					start: "sm_vomitplayer @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "1 HP Survivors",
					start: "sm_sethpplayer @survivors 1; sm_settemphpplayer 0",
					end: "sm_sethpplayer @survivors 80; sm_settemphpplayer 0",
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
				}
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
					start: "sm_cvarsilent z_speed 80",
					end: "sm_cvarsilent z_speed 250",
					active_time: "long"
				},
				{
					text: "Marathon Zombies",
					start: "sm_cvarsilent z_speed 500",
					end: "sm_cvarsilent z_speed 250",
					active_time: "long"
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
					start: "sm_entityrain @all witch 2",
					end: "",
					active_time: "none"
				}
			]
		}
	]
}

