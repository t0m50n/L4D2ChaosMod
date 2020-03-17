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
					start: "sm_cvar sv_gravity 400",
					end: "sm_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Double Gravity",
					start: "sm_cvar sv_gravity 1600",
					end: "sm_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Quarter Gravity",
					start: "sm_cvar sv_gravity 200",
					end: "sm_cvar sv_gravity 800",
					active_time: "normal"
				},
				{
					text: "Zero Gravity",
					start: "sm_cvar sv_gravity 0",
					end: "sm_cvar sv_gravity 800",
					active_time: "short"
				},
				{
					text: "Shuffle names",
					start: "sm_rename @all",
					end: "",
					active_time: "none"
				},
				{
					text: "Throw everyone",
					start: "sm_charge @all 600",
					end: "",
					active_time: "none"
				},
				{
					text: "Dissolve infected on death",
					start: "sm_cvar l4d_dissolve_allow 1",
					end: "sm_cvar l4d_dissolve_allow 0",
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
					start: "sm_cvar survivor_crouch_speed 400",
					end: "sm_cvar survivor_crouch_speed 75",
					active_time: "short"
				},
				{
					text: "Infinite Ammo",
					start:"sm_cvar sv_infinite_ammo 1",
					end:"sm_cvar sv_infinite_ammo 0",
					active_time: "normal"
				},
				{
					text: "Bots Keep Shooting",
					start: "sm_cvar sb_open_fire 1",
					end: "sm_cvar sb_open_fire 0",
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
					text: "Too many pills",
					start: "sm_drug @survivors 1",
					end: "sm_drug @survivors 0",
					active_time: "normal"
				},
				{
					text: "Teleport back to saferoom",
					start: "sm_dontrush @survivors",
					end: "",
					active_time: "none"
				},
				{
					text: "Big pants",
					start: "sm_sizeplayer @survivors 4",
					end: "sm_sizeplayer @survivors 1",
					active_time: "normal"
				},
				{
					text: "Vomit survivors",
					start: "sm_vomitplayer @survivors",
					end: "sm_vomitplayer @survivors",
					active_time: "none"
				},
				{
					text: "1 hp survivors",
					start: "sm_sethpplayer @survivors 1",
					end: "sm_sethpplayer @survivors 80",
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
					start: "sm_cvar z_speed 80",
					end: "sm_cvar z_speed 250",
					active_time: "normal"
				},
				{
					text: "Marathon Zombies",
					start: "sm_cvar z_speed 500",
					end: "sm_cvar z_speed 250",
					active_time: "normal"
				},
				{
					text: "1 Hit Zombies",
					start: "sm_cvar z_health 1",
					end: "sm_cvar z_health 50",
					active_time: "normal"
					
				},
				{
					text: "Tough Zombies",
					start:"sm_cvar z_health 400",
					end:"sm_cvar z_health 50",
					active_time: "long"
				},
				{
					text: "Endless Hordes",
					start: "exec sourcemod/chaosmod/endless_hordes_start",
					end: "exec sourcemod/chaosmod/endless_hordes_end",
					active_time: "normal"
				}
			]
		}
	]
}

