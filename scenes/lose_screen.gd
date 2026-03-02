extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$LoseSound.play()

	
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
