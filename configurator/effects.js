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
					text:"Tough Zombies",
					start:"sm_cvar z_health 400",
					end:"sm_cvar z_health 50",
					active_time: "long"
				}
			]
		}
	]
}

