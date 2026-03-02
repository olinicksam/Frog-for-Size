extends Node2D

@export var enemy_scene : PackedScene
@export var strong_enemy_scene : PackedScene
@export var spawn_rate:= 4.5

var spawn_timer := 0.0
var spawning := false
var current_wave := 1

func start_wave(wave): 
	current_wave = wave
	spawning = true 
	spawn_timer = 0.0 

# scale difficulty slightly
	spawn_rate = max(0.5,2.0 - (wave * 0.2))

func stop_wave():
	spawning = false
	
func _process(_delta: float) -> void:
	if not spawning:
		return

	spawn_timer -= _delta
	
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = spawn_rate

func spawn_enemy():
	var enemy
	
	var strong_spawn_chance := 0.0
	
	if current_wave >= 2:
		strong_spawn_chance = min(0.10 * (current_wave -1), 0.50)
	
	if randf() < strong_spawn_chance:
		enemy = strong_enemy_scene.instantiate()
		var speed_bonus := (current_wave -2) * 50
		enemy.speed += speed_bonus
	else: 
		enemy = enemy_scene.instantiate()
	
	enemy.global_position = get_random_spawn_position()
	get_parent().add_child(enemy)
	
func get_random_spawn_position() -> Vector2: 
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var spawn_radius := 900 
		var angle = randf() * TAU
		var offset = Vector2.RIGHT.rotated(angle) * spawn_radius
		return player.global_position + offset
	else: 
		var map_width: int = 1200 
		var map_height: int = 700
		return Vector2(
			randf_range(50, map_width - 50),
			randf_range(50, map_height - 50)
		)
