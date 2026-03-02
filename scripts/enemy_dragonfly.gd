extends CharacterBody2D

@export var speed:= 200
@export var max_hp:= 5
@export var damage := 2
@export var attack_cooldown := 2.0

var attack_timer := 0.0
var hp
var player

func _ready():
	hp = max_hp
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if attack_timer > 0:
		attack_timer -= _delta
	
	if player: 
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	if player:
		var direction = player.global_position - global_position
		$AnimatedSprite2D.rotation = direction.angle() + PI/2
		
func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()
		
func die():
	player.grow()
	queue_free()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if attack_timer <= 0 and body.is_in_group("player"):
		body.take_damage(damage)
		attack_timer = attack_cooldown
