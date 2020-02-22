let effects_tree = {
	"text": "All",
	"state": {
		"opened": true,
		"checked": true
	},
	"children": [
		{
			"text": "Global",
			"state": {
				"opened": true
			},
			"children": [
				{
					"text": "Half Gravity",
					"start": "sm_cvar sv_gravity 400",
					"end": "sm_cvar sv_gravity 800",
					"active_time": "normal"
				},
				{
					"text": "Double Gravity",
					"start": "sm_cvar sv_gravity 1600",
					"end": "sm_cvar sv_gravity 800",
					"active_time": "normal"
				}
			]
		}
	]
}

