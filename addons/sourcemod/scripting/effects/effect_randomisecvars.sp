StringMap g_cvar_groups;

void Effect_RandomiseCvars_OnPluginStart()
{
	StringMap si_cvars = new StringMap();
	// cvar name -> default, min, max
	si_cvars.SetArray("smoker_escape_range", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("smoker_pz_claw_dmg", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("smoker_tongue_delay", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("survivor_hanging_from_tongue_eye_height", {40.0, 10.0, 160.0}, 3);
	si_cvars.SetArray("survivor_incap_tongued_decay_rate", {12.0, 3.0, 48.0}, 3);
	si_cvars.SetArray("survivor_max_tongue_stagger_distance", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("survivor_max_tongue_stagger_duration", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("tongue_allow_voluntary_release", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("tongue_bend_point_deflection", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("tongue_bend_point_needs_los", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("tongue_break_from_damage_amount", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("tongue_bullet_radius", {6.0, 1.5, 24.0}, 3);
	si_cvars.SetArray("tongue_choke_damage_amount", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("tongue_choke_damage_interval", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tongue_cone_start_tolerance", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("tongue_drag_damage_amount", {3.0, 0.8, 12.0}, 3);
	si_cvars.SetArray("tongue_dropping_to_ground_time", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("tongue_fly_speed", {1000.0, 250.0, 4000.0}, 3);
	si_cvars.SetArray("tongue_gravity_force", {4000.0, 1000.0, 16000.0}, 3);
	si_cvars.SetArray("tongue_health", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("tongue_hit_delay", {20.0, 5.0, 80.0}, 3);
	si_cvars.SetArray("tongue_los_forgiveness_time", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tongue_miss_delay", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("tongue_no_progress_break_interval", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("tongue_no_progress_choke_early_ambush_delay", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("tongue_no_progress_choke_early_delay", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("tongue_no_progress_choke_time", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("tongue_no_progress_damage_interval", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("tongue_no_progress_tolerance", {25.0, 6.3, 100.0}, 3);
	si_cvars.SetArray("tongue_player_dropping_to_ground_time", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tongue_range", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("tongue_release_fatigue_penalty", {2500.0, 625.0, 10000.0}, 3);
	si_cvars.SetArray("tongue_start_pull_delay", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("tongue_unbend", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tongue_vertical_choke_height", {40.0, 10.0, 160.0}, 3);
	si_cvars.SetArray("tongue_vertical_choke_time_off_ground", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("tongue_victim_acceleration", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("tongue_victim_accuracy_penalty", {0.1, 0.0, 0.5}, 3);
	si_cvars.SetArray("tongue_victim_max_speed", {175.0, 43.8, 700.0}, 3);
	si_cvars.SetArray("tongue_vs_cone_start_tolerance", {0.0, 0.0, 0.1}, 3);
	si_cvars.SetArray("z_witch_tongue_range", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("hunter_committed_attack_range", {75.0, 18.8, 300.0}, 3);
	si_cvars.SetArray("hunter_leap_away_give_up_range", {1000.0, 250.0, 4000.0}, 3);
	si_cvars.SetArray("hunter_pounce_air_speed", {700.0, 175.0, 2800.0}, 3);
	si_cvars.SetArray("hunter_pounce_loft_rate", {0.0, 0.0, 0.1}, 3);
	si_cvars.SetArray("hunter_pounce_max_loft_angle", {45.0, 11.3, 180.0}, 3);
	si_cvars.SetArray("hunter_pounce_ready_range", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("hunter_pz_claw_dmg", {6.0, 1.5, 24.0}, 3);
	si_cvars.SetArray("survivor_max_lunge_stagger_speed", {220.0, 55.0, 880.0}, 3);
	si_cvars.SetArray("survivor_min_lunge_stagger_speed", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("versus_shove_hunter_fov", {90.0, 22.5, 360.0}, 3);
	si_cvars.SetArray("versus_shove_hunter_fov_pouncing", {45.0, 11.3, 180.0}, 3);
	si_cvars.SetArray("z_hunter_ground_normal", {0.2, 0.1, 0.8}, 3);
	si_cvars.SetArray("z_hunter_health", {250.0, 62.5, 1000.0}, 3);
	si_cvars.SetArray("z_hunter_lunge_distance", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("z_hunter_lunge_pitch", {25.0, 6.3, 100.0}, 3);
	si_cvars.SetArray("z_hunter_lunge_stagger_time", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_hunter_max_pounce_bonus_damage", {24.0, 6.0, 96.0}, 3);
	si_cvars.SetArray("z_hunter_speed", {300.0, 75.0, 1200.0}, 3);
	si_cvars.SetArray("z_max_hunter_pounce_stagger_duration", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("z_pounce_stumble_force", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_versus_hunter_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("jockey_pounce_air_speed", {700.0, 175.0, 2800.0}, 3);
	si_cvars.SetArray("jockey_pounce_loft_rate", {0.0, 0.0, 0.1}, 3);
	si_cvars.SetArray("jockey_pounce_max_loft_angle", {45.0, 11.3, 180.0}, 3);
	si_cvars.SetArray("sb_friend_immobilized_reaction_time_expert", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("sb_friend_immobilized_reaction_time_hard", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("sb_friend_immobilized_reaction_time_normal", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("sb_friend_immobilized_reaction_time_vs", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("survivor_pounce_victim_eye_height", {12.0, 3.0, 48.0}, 3);
	si_cvars.SetArray("z_pounce_allow_partial_hidden", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_pounce_crouch_delay", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_pounce_damage", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_pounce_damage_delay", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_pounce_damage_interrupt", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("z_pounce_damage_interval", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("z_pounce_door_damage", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("z_pounce_shake_amplitude", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("z_pounce_shake_duration", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("z_pounce_shake_radius", {250.0, 62.5, 1000.0}, 3);
	si_cvars.SetArray("z_pounce_silence_range", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("boomer_exposed_time_tolerance", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("boomer_pz_claw_dmg", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("boomer_vomit_delay", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("sb_vomit_blind_time", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_boomer_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_boomer_near_dist", {180.0, 45.0, 720.0}, 3);
	si_cvars.SetArray("z_exploding_splat", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("z_exploding_splat_radius", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_female_boomer_spawn_chance", {25.0, 6.3, 100.0}, 3);
	si_cvars.SetArray("z_versus_boomer_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_vomit_boxsize", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_vomit_drag", {0.9, 0.2, 3.6}, 3);
	si_cvars.SetArray("z_vomit_duration", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("z_vomit_fade_duration", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_vomit_fade_start", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_vomit_fatigue", {3000.0, 0.1, 3001.0}, 3);
	si_cvars.SetArray("z_vomit_float", {-130.0, -32.5, -520.0}, 3);
	si_cvars.SetArray("z_vomit_hit_pitch_max", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("z_vomit_hit_pitch_min", {-15.0, -3.8, -60.0}, 3);
	si_cvars.SetArray("z_vomit_hit_yaw_max", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_vomit_hit_yaw_min", {-10.0, -2.5, -40.0}, 3);
	si_cvars.SetArray("z_vomit_interval", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("z_vomit_lifetime", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("z_vomit_maxdamagedist", {350.0, 87.5, 1400.0}, 3);
	si_cvars.SetArray("z_vomit_range", {300.0, 75.0, 1200.0}, 3);
	si_cvars.SetArray("z_vomit_slide_mult", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("z_vomit_slide_rate", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("z_vomit_vecrand", {0.1, 0.0, 0.2}, 3);
	si_cvars.SetArray("z_vomit_velocity", {1700.0, 425.0, 6800.0}, 3);
	si_cvars.SetArray("z_vomit_velocityfadeend", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("z_vomit_velocityfadestart", {0.3, 0.1, 1.2}, 3);
	si_cvars.SetArray("ammo_turret_tank_damage", {40.0, 10.0, 160.0}, 3);
	si_cvars.SetArray("director_custom_finale_tank_spacing", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("director_tank_bypass_max_flow_travel", {1500.0, 375.0, 6000.0}, 3);
	si_cvars.SetArray("director_tank_checkpoint_interval", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("director_tank_lottery_entry_time", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("director_tank_lottery_selection_time", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("director_tank_max_interval", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("director_tank_min_interval", {350.0, 87.5, 1400.0}, 3);
	si_cvars.SetArray("tank_attack_range", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("tank_auto_swing", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("tank_burn_duration", {75.0, 18.8, 300.0}, 3);
	si_cvars.SetArray("tank_burn_duration_expert", {85.0, 21.3, 340.0}, 3);
	si_cvars.SetArray("tank_burn_duration_hard", {80.0, 20.0, 320.0}, 3);
	si_cvars.SetArray("tank_fist_radius", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("tank_ground_pound_duration", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("tank_ground_pound_reveal_distance", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("tank_pz_forward", {-0.5, -0.1, -2.0}, 3);
	si_cvars.SetArray("tank_rock_overhead_percent", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("tank_run_spawn_delay", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("tank_stasis_time_suicide", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("tank_stuck_failsafe", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tank_stuck_time_choose_new_target", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("tank_stuck_time_suicide", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("tank_stuck_visibility_tolerance_choose_new_target", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("tank_stuck_visibility_tolerance_suicide", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("tank_swing_arc", {180.0, 45.0, 720.0}, 3);
	si_cvars.SetArray("tank_swing_duration", {0.2, 0.1, 0.8}, 3);
	si_cvars.SetArray("tank_swing_fast_interval", {0.6, 0.2, 2.4}, 3);
	si_cvars.SetArray("tank_swing_interval", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("tank_swing_miss_interval", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("tank_swing_physics_prop_force", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("tank_swing_range", {56.0, 14.0, 224.0}, 3);
	si_cvars.SetArray("tank_swing_yaw", {80.0, 20.0, 320.0}, 3);
	si_cvars.SetArray("tank_throw_aim_error", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("tank_throw_allow_range", {250.0, 62.5, 1000.0}, 3);
	si_cvars.SetArray("tank_throw_lead_time_factor", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("tank_throw_loft_rate", {0.0, 0.0, 0.0}, 3);
	si_cvars.SetArray("tank_throw_max_loft_angle", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("tank_throw_min_interval", {8.0, 2.0, 32.0}, 3);
	si_cvars.SetArray("tank_visibility_tolerance_suicide", {60.0, 15.0, 240.0}, 3);
	si_cvars.SetArray("tank_windup_time", {0.5, 0.1, 2.0}, 3);
	si_cvars.SetArray("vs_tank_damage", {24.0, 6.0, 96.0}, 3);
	si_cvars.SetArray("z_debug_tank_spawn", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_finale_spawn_tank_safety_range", {600.0, 150.0, 2400.0}, 3);
	si_cvars.SetArray("z_frustration_lifetime", {20.0, 5.0, 80.0}, 3);
	si_cvars.SetArray("z_tank_attack_interval", {1.5, 0.4, 6.0}, 3);
	si_cvars.SetArray("z_tank_autoshotgun_dmg_scale", {0.9, 0.2, 3.4}, 3);
	si_cvars.SetArray("z_tank_damage_slow_max_range", {400.0, 100.0, 1600.0}, 3);
	si_cvars.SetArray("z_tank_damage_slow_min_range", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_tank_footstep_shake_amplitude", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_tank_footstep_shake_duration", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("z_tank_footstep_shake_interval", {0.4, 0.1, 1.6}, 3);
	si_cvars.SetArray("z_tank_footstep_shake_radius", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("z_tank_grenade_damage", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("z_tank_grenade_launcher_dmg_scale", {3.0, 0.8, 12.0}, 3);
	si_cvars.SetArray("z_tank_grenade_roll", {-10.0, -2.5, -40.0}, 3);
	si_cvars.SetArray("z_tank_grenade_slowdown", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("z_tank_has_special_blood", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("z_tank_health", {4000.0, 1000.0, 16000.0}, 3);
	si_cvars.SetArray("z_tank_incapacitated_decay_rate", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_tank_incapacitated_health", {5000.0, 1250.0, 20000.0}, 3);
	si_cvars.SetArray("z_tank_max_stagger_distance", {400.0, 100.0, 1600.0}, 3);
	si_cvars.SetArray("z_tank_max_stagger_duration", {6.0, 1.5, 24.0}, 3);
	si_cvars.SetArray("z_tank_max_stagger_fade_duration", {6.0, 1.5, 24.0}, 3);
	si_cvars.SetArray("z_tank_rock_radius", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("z_tank_speed", {210.0, 52.5, 840.0}, 3);
	si_cvars.SetArray("z_tank_speed_vs", {210.0, 52.5, 840.0}, 3);
	si_cvars.SetArray("z_tank_stagger_fade_alpha", {192.0, 48.0, 768.0}, 3);
	si_cvars.SetArray("z_tank_stagger_fade_duration", {3.0, 0.8, 12.0}, 3);
	si_cvars.SetArray("z_tank_throw_force", {800.0, 200.0, 3200.0}, 3);
	si_cvars.SetArray("z_tank_throw_health", {50.0, 12.5, 200.0}, 3);
	si_cvars.SetArray("z_tank_throw_interval", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_tank_walk_speed", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("z_tanks_block_molotovs", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_charger_allow_shove", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("z_charger_health", {600.0, 150.0, 2400.0}, 3);
	si_cvars.SetArray("z_charger_impact_epsilon", {8.0, 2.0, 32.0}, 3);
	si_cvars.SetArray("z_charger_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_charger_max_prop_force", {3000.0, 750.0, 12000.0}, 3);
	si_cvars.SetArray("z_charger_pound_dmg", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("z_charger_probe_alone", {6.0, 1.5, 24.0}, 3);
	si_cvars.SetArray("z_charger_probe_attack", {24.0, 6.0, 96.0}, 3);
	si_cvars.SetArray("z_versus_charger_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("jockey_pz_claw_dmg", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("versus_shove_jockey_fov_leaping", {45.0, 11.3, 180.0}, 3);
	si_cvars.SetArray("z_jockey_area_current_factor", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_area_hazard_bonus", {3000.0, 750.0, 12000.0}, 3);
	si_cvars.SetArray("z_jockey_area_range_factor", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("z_jockey_area_visibility_factor", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("z_jockey_blend_rate", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_control_max", {0.8, 0.2, 3.2}, 3);
	si_cvars.SetArray("z_jockey_control_min", {0.8, 0.2, 3.2}, 3);
	si_cvars.SetArray("z_jockey_control_variance", {0.7, 0.2, 2.8}, 3);
	si_cvars.SetArray("z_jockey_health", {325.0, 81.3, 1300.0}, 3);
	si_cvars.SetArray("z_jockey_leap_again_timer", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_jockey_leap_range", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_jockey_leap_time", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_lookahead", {400.0, 100.0, 1600.0}, 3);
	si_cvars.SetArray("z_jockey_min_ledge_distance", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_jockey_min_mounted_speed", {0.6, 0.2, 2.4}, 3);
	si_cvars.SetArray("z_jockey_ride_damage", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("z_jockey_ride_damage_delay", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_ride_damage_interval", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_jockey_ride_hazard_scan_distance", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("z_jockey_ride_scan_distance", {800.0, 200.0, 3200.0}, 3);
	si_cvars.SetArray("z_jockey_ride_scan_interval", {3.0, 0.8, 12.0}, 3);
	si_cvars.SetArray("z_jockey_speed", {250.0, 62.5, 1000.0}, 3);
	si_cvars.SetArray("z_jockey_speed_blend", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("z_jockey_stagger_speed", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("z_versus_jockey_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("spitter_pz_claw_dmg", {4.0, 1.0, 16.0}, 3);
	si_cvars.SetArray("z_spitter_health", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("z_spitter_high_chance", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_spitter_limit", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_spitter_max_wait_time", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("z_spitter_range", {850.0, 212.5, 3400.0}, 3);
	si_cvars.SetArray("z_spitter_speed", {210.0, 52.5, 840.0}, 3);
	si_cvars.SetArray("gascan_spit_time", {2.9, 0.7, 11.6}, 3);
	si_cvars.SetArray("spit_scaling_min_scale", {0.4, 0.1, 1.4}, 3);
	si_cvars.SetArray("z_spit_detonate_delay", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("z_spit_interval", {20.0, 5.0, 80.0}, 3);
	si_cvars.SetArray("z_spit_latency", {0.3, 0.1, 1.2}, 3);
	si_cvars.SetArray("z_spit_range", {900.0, 225.0, 3600.0}, 3);
	si_cvars.SetArray("z_spit_spread_delay", {0.2, 0.1, 0.8}, 3);
	si_cvars.SetArray("z_spit_velocity", {900.0, 225.0, 3600.0}, 3);
	si_cvars.SetArray("ammo_turret_witch_damage", {16.0, 4.0, 64.0}, 3);
	si_cvars.SetArray("claw_force", {240.0, 60.0, 960.0}, 3);
	si_cvars.SetArray("music_dynamic_witch_alert_interval", {37.0, 9.3, 148.0}, 3);
	si_cvars.SetArray("music_dynamic_witch_near_max", {1800.0, 450.0, 7200.0}, 3);
	si_cvars.SetArray("music_dynamic_witch_near_min", {360.0, 90.0, 1440.0}, 3);
	si_cvars.SetArray("survivor_calm_deploy_delay", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("versus_witch_chance", {0.8, 0.2, 3.0}, 3);
	si_cvars.SetArray("versus_witch_chance_finale", {0.1, 0.0, 0.4}, 3);
	si_cvars.SetArray("versus_witch_chance_intro", {0.3, 0.1, 1.2}, 3);
	si_cvars.SetArray("witch_rage_ramp_duration", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_witch_allow_change_victim", {1.0, 0.3, 4.0}, 3);
	si_cvars.SetArray("z_witch_always_kills", {0.0, 0.0, 1.0}, 3);
	si_cvars.SetArray("z_witch_anger_rate", {0.2, 0.1, 0.8}, 3);
	si_cvars.SetArray("z_witch_attack_range", {60.0, 15.0, 240.0}, 3);
	si_cvars.SetArray("z_witch_berserk_range", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_witch_burn_time", {15.0, 3.8, 60.0}, 3);
	si_cvars.SetArray("z_witch_damage", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("z_witch_damage_per_kill_hit", {30.0, 7.5, 120.0}, 3);
	si_cvars.SetArray("z_witch_discard_range", {2000.0, 500.0, 8000.0}, 3);
	si_cvars.SetArray("z_witch_flashlight_range", {400.0, 100.0, 1600.0}, 3);
	si_cvars.SetArray("z_witch_health", {1000.0, 250.0, 4000.0}, 3);
	si_cvars.SetArray("z_witch_hostile_at_me_anger", {2.0, 0.5, 8.0}, 3);
	si_cvars.SetArray("z_witch_max_retreat_range", {2000.0, 500.0, 8000.0}, 3);
	si_cvars.SetArray("z_witch_max_threat_time", {7.0, 1.8, 28.0}, 3);
	si_cvars.SetArray("z_witch_min_retreat_range", {750.0, 187.5, 3000.0}, 3);
	si_cvars.SetArray("z_witch_min_threat_time", {5.0, 1.3, 20.0}, 3);
	si_cvars.SetArray("z_witch_personal_space", {100.0, 25.0, 400.0}, 3);
	si_cvars.SetArray("z_witch_relax_rate", {0.1, 0.0, 0.2}, 3);
	si_cvars.SetArray("z_witch_retreat_exit_hidden_duration", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_witch_retreat_exit_range", {1000.0, 250.0, 4000.0}, 3);
	si_cvars.SetArray("z_witch_retreat_min_duration", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_witch_speed", {300.0, 75.0, 1200.0}, 3);
	si_cvars.SetArray("z_witch_speed_inured", {200.0, 50.0, 800.0}, 3);
	si_cvars.SetArray("z_witch_threat_hostile_range", {600.0, 150.0, 2400.0}, 3);
	si_cvars.SetArray("z_witch_threat_normal_range", {300.0, 75.0, 1200.0}, 3);
	si_cvars.SetArray("z_witch_wander_hear_radius", {72.0, 18.0, 288.0}, 3);
	si_cvars.SetArray("z_witch_wander_music_max_dist", {2000000.0, 500000.0, 8000000.0}, 3);
	si_cvars.SetArray("z_witch_wander_music_max_interval", {20.0, 5.0, 80.0}, 3);
	si_cvars.SetArray("z_witch_wander_music_min_dist", {90000.0, 22500.0, 360000.0}, 3);
	si_cvars.SetArray("z_witch_wander_music_min_interval", {3.0, 0.8, 12.0}, 3);
	si_cvars.SetArray("z_witch_wander_personal_space", {240.0, 60.0, 960.0}, 3);
	si_cvars.SetArray("z_witch_wander_personal_time", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_charge_duration", {2.5, 0.6, 10.0}, 3);
	si_cvars.SetArray("z_charge_impact_angle", {0.7, 0.2, 2.8}, 3);
	si_cvars.SetArray("z_charge_impact_radius", {120.0, 30.0, 480.0}, 3);
	si_cvars.SetArray("z_charge_interval", {12.0, 3.0, 48.0}, 3);
	si_cvars.SetArray("z_charge_max_damage", {10.0, 2.5, 40.0}, 3);
	si_cvars.SetArray("z_charge_max_force", {800.0, 200.0, 3200.0}, 3);
	si_cvars.SetArray("z_charge_max_speed", {500.0, 125.0, 2000.0}, 3);
	si_cvars.SetArray("z_charge_min_force", {550.0, 137.5, 2200.0}, 3);
	si_cvars.SetArray("z_charge_prop_damage", {20.0, 5.0, 80.0}, 3);
	si_cvars.SetArray("z_charge_start_speed", {250.0, 62.5, 1000.0}, 3);
	si_cvars.SetArray("z_charge_warmup", {0.5, 0.1, 2.0}, 3);

	g_cvar_groups = new StringMap();
	g_cvar_groups.SetValue("si", si_cvars);
}

public Action Command_RandomiseCvars(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: chaosmod_randomisecvars <cvar group> [to defaults?]");
		return Plugin_Handled;
	}
	char cvar_group[255];
	GetCmdArg(1, cvar_group, sizeof(cvar_group));

	StringMap cvars;
	if (!g_cvar_groups.GetValue(cvar_group, cvars))
	{
		ReplyToCommand(client, "[SM] Cvar group not found.");
		return Plugin_Handled;
	}

	bool defaults = false;
	if (args > 1)
	{
		char s_defaults[255];
		GetCmdArg(2, s_defaults, sizeof(s_defaults));
		defaults = StringToInt(s_defaults) == 1;
	}

	RandomiseCvars(cvars, defaults);
	return Plugin_Handled;
}

void RandomiseCvars(StringMap cvars, bool defaults)
{
	StringMapSnapshot cvar_names = cvars.Snapshot();
	for (int i = 0; i < cvar_names.Length; i++)
	{
		char cv_name[255];
		cvar_names.GetKey(i, cv_name, sizeof(cv_name));

		float cv_vals[3];
		cvars.GetArray(cv_name, cv_vals, 3);

		float val;
		if (defaults)
		{
			val = cv_vals[0];
		}
		else if (GetRandomInt(0, 1) == 0)
		{
			val = GetRandomFloat(cv_vals[1], cv_vals[0]);
		}
		else {
			val = GetRandomFloat(cv_vals[0], cv_vals[2]);
		}

		ConVar cv = FindConVar(cv_name);
		cv.SetFloat(val);
		// delete cv; not required?
	}
	delete cvar_names;
}