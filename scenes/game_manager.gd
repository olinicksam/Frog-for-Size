extends Node2D

@export var wave_time := 35
@export var max_waves := 5

var wave_timer := 0.0
var current_wave := 1
var timer := 0.0
var shrink_jar_scene = preload("res://scenes/shrink_jar.tscn")

@onready var wave_label: Label = $"../UI/topbar/WaveLabel"
@onready var enemy_manager: Node2D = $"../EnemyManager"
@onready var frog_player: CharacterBody2D = $"../FrogPlayer"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer_label: Label = $"../UI/topbar/TimerLabel"


func _ready() -> void:
	player.grew.connect(_on_player_grew)
	start_wave()
	
func _process(_delta: float) -> void:
	if timer > 0:
		timer -= _delta
		wave_timer += _delta
		update_timer_label()
	else:
		end_wave()
	
func start_wave():
	print("Starting wave", current_wave)
	timer = wave_time 
	enemy_manager.start_wave(current_wave)
	wave_label.text = "Wave " + str(current_wave)
	$"../UI/HPBar".visible = true
	
	
func end_wave():
	print("Wave ended")
	enemy_manager.stop_wave()
	SFXUpgrade.play_upgrade()
	
	# clear all enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	
	#reset player
	frog_player.hp = frog_player.max_hp
	frog_player.scale = frog_player.base_scale
	
	open_upgrade_screen()

func open_upgrade_screen():
	print("opening upgrade screen")
	get_tree().paused = true
	$"../UI".show_upgrade_screen()

func upgrade_selected():
	get_tree().paused = false
	
	current_wave += 1
	
	if current_wave > max_waves:
		win_game()
	else:
		start_wave()

func win_game():
	SFXManager.play_win()
	get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
	enemy_manager.stop_wave()
	set_process(false)

func _on_player_grew():
	if randf() < 0.5:
		spawn_shrink_jar()


func spawn_shrink_jar():
	var jar = shrink_jar_scene.instantiate()
	var spawn_radius = 1000
	var angle = randf() * TAU
	var offset = Vector2.RIGHT.rotated(angle) * spawn_radius
	
	jar.global_position = player.global_position + offset
	
	add_child(jar)

func update_timer_label():
	var seconds = int(ceil(timer))  # round up so 35 → 1 correctly
	var minutes = seconds / 60
	seconds = seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
