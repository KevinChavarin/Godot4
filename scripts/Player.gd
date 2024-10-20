extends CharacterBody2D

# Combat system variables
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
@onready var sword_hitbox = $AnimatedSprite2D/sword_hitbox


# Movement variables
var input = Vector2.ZERO

const max_speed = 100
const accel = 1000
const friction = 2000
var currentDirection = "none"

var attack_ip = false

func _ready():
	$AnimatedSprite2D.play("Idle_front")

func _physics_process(delta):
	playerMovement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
	
func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return input.normalized()
	
# Function for the player movement
func playerMovement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else: 
			velocity = Vector2.ZERO
	else: 
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	if input.x >= 1:
		currentDirection = "right"
		player_anim(1)
		
	elif input.x <= -1:
		currentDirection = "left"
		player_anim(1)
		
	elif input.y >= 1:
		currentDirection = "down"
		player_anim(1)
	elif input.y <= -1:
		currentDirection = "up"
		player_anim(1)
	elif input.x == 0 and input.y == 0:
		player_anim(0)
	
	move_and_slide()

# Function to handle the sprite changes based on movement
func player_anim(movement):
	var dir = currentDirection
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			sword_hitbox.scale.x = 1
			anim.play("Walking_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("Idle_right")
			
	if dir == "left":
		sword_hitbox.scale.x = -1
		anim.flip_h = true
		if movement == 1:
			anim.play("Walking_right")
		elif movement == 0:
			if attack_ip == false:
				anim.play("Idle_right")
			
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walking_back")
		elif movement == 0:
			if attack_ip == false:
				anim.play("Idle_back")
			
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walking_front")
		elif movement == 0:
			if attack_ip == false:
				anim.play("Idle_front")

# For recognition and filtering
func player():
	pass

# Detects if an enemy is in attack range
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

# Detects if an enemy leaves the attack range
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false


func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

# Deals with the attack animation
func attack():
	var dir = currentDirection
	
	if Input.is_mouse_button_pressed(1) and dir == "right":
		$AnimatedSprite2D/sword_hitbox/horizontal.disabled = false
	elif Input.is_mouse_button_pressed(1) and dir == "left":
		$AnimatedSprite2D/sword_hitbox/horizontal.disabled = false
	elif Input.is_mouse_button_pressed(1) and dir == "down":
		$AnimatedSprite2D/sword_hitbox/vertical.disabled = false
	else:
		$AnimatedSprite2D/sword_hitbox/horizontal.disabled = true
		$AnimatedSprite2D/sword_hitbox/vertical.disabled = true

	if Input.is_action_just_pressed("attack"):
		global.player_currently_attacking = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Attack_right")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Attack_right")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("Attack_front")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("Attack_back")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_currently_attacking = false
	attack_ip = false


func _on_sword_hitbox_body_entered(body):
	if body.is_in_group("Hit"):
		body.deal_with_damage()
	else:
		pass

#To show the health bar
func update_health():
	var healthbar = $health_bar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

# To heal over time
func _on_regen_timer_timeout():
	if health < 100:
		health += 20
		if health > 100:
			health = 100
		elif health <= 0:
			health = 0 
