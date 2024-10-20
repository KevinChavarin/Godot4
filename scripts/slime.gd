extends CharacterBody2D

# Movement variables
var speed = 45
var player_chase = false
var player = null

# Combat variables
var health = 100
var player_in_attack_zone = false

var can_take_dmg = true

# For the slime to chase the player
func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("Walking_right")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif !player_chase and health != 0:
		$AnimatedSprite2D.play("Idle_right")

# For the slime to detect if player enters or exits the chase zone
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_slime_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true
	

func _on_slime_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		
func deal_with_damage():
	if player_in_attack_zone and global.player_currently_attacking == true:
		if can_take_dmg == true and health != 0:
			health -= 20
			$take_damage_cooldown.start()
			can_take_dmg = false
			print("slime health: ", health)
			
			#ERROR HERE
			player_chase = false
			$AnimatedSprite2D.play("Damaged")
			await get_tree().create_timer(0.4).timeout
			player_chase = true
			
		if health == 0:
			player_chase = false
			$AnimatedSprite2D.play("Death")
			await get_tree().create_timer(1).timeout
			self.queue_free()




func _on_take_damage_cooldown_timeout():
	can_take_dmg = true
	
func update_health():
	var health_bar = $health_bar
	health_bar.value = health
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true


func _on_regen_timer_timeout():
	pass # Replace with function body.
