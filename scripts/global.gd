extends Node

var player_currently_attacking = false

var current_scene = "First_level"
var transition_scene = false

var game_first_loading = true

var player_exit_cliffside_posx = 127
var player_exit_cliffside_posy = 14
var player_start_posx = 61
var player_start_posy = 65

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
