extends Node2D

func _ready():
	if global.game_first_loading == true:
		$Player.position.x = global.player_start_posx
		$Player.position.y = global.player_start_posy
	else:
		$Player.position.x = global.player_exit_cliffside_posx
		$Player.position.y = global.player_exit_cliffside_posy

func _process(delta):
	change_scene()

func _on_cliffside_transition_area_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliffside_transition_area_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "First_level":
				global.current_scene = "cliff_scene"
				get_tree().change_scene_to_file("res://scenes/cliff_scene.tscn")
				global.game_first_loading = false
				global.finish_changescenes()
