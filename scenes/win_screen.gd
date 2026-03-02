extends Control

func _ready() -> void:
	$win.play()

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
