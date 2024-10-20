extends Node2D

func _process(delta):
	change_scene()


func _on_cliff_side_exit_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_cliff_side_exit_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "cliff_scene":
			global.current_scene = "First_level"
			get_tree().change_scene_to_file("res://scenes/First_level.tscn")
			global.finish_changescenes()
