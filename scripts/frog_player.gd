extends CharacterBody2D

signal grew

@export var speed:= 700
@export var tongue_range:= 350
@export var tongue_damage:= 1
@export var tongue_duration:= 0.1

var max_hp := 5
var hp := 5
var tongue_timer := 0.0
var growth_per_kill:= 0.3
var base_scale:= Vector2.ONE

func _ready():
	$TongueRay.target_position = Vector2(tongue_range, 0)

func _physics_process(_delta):
	handle_movement()
	look_at((get_global_mouse_position()))
	
	if Input.is_action_just_pressed("shoot"):
		attack()
		
		
	if tongue_timer > 0:
		tongue_timer -= _delta
		if tongue_timer <= 0:
			$TongueRay/TongueSprite.visible = false

func handle_movement():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = input_dir * speed
	move_and_slide()
	
	if input_dir != Vector2.ZERO:
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.stop()
			

func attack():
	$TongueRay.force_raycast_update()
	$AudioStreamPlayer2D.play()
	
	var hit_position = global_position + ($TongueRay.target_position.rotated(rotation))
	if$TongueRay.is_colliding():
		var body = $TongueRay.get_collider()
		if body.has_method("take_damage"):
			body.take_damage(tongue_damage)
		hit_position = $TongueRay.get_collision_point()
	show_tongue(hit_position)
	

func show_tongue(hit_position):
	var distance = global_position.distance_to(hit_position)
	
	$TongueRay/TongueSprite.visible = true
	$TongueOrigin.rotation = rotation
	$TongueRay/TongueSprite.scale.x = distance / $TongueRay/TongueSprite.texture.get_size().x

	tongue_timer = tongue_duration


func grow():
	global_scale += Vector2.ONE * growth_per_kill
	emit_signal("grew")


func apply_upgrade(type):
	match type:
		"damage":
			tongue_damage += 1
		"speed":
			speed += 25
		"hp":
			max_hp += 1
			hp = max_hp #refill on upgrade
		"growth_control":
			growth_per_kill *= 0.8 #grow slower per kill

func take_damage(amount):
	hp -= amount
	$bonk.play()
	if hp <= 0:
		die()

func die():
	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")
