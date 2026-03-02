extends CanvasLayer

@onready var panel = $UpgradePanel
@onready var hp_bar: ProgressBar = $HPBar
@onready var player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if player:
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.hp
		
func show_upgrade_screen():
	print("showing panel")
	$UpgradePanel.visible = true 
	$HPBar.visible = false
	
func choose_upgrade(type):
	if player:
		player.apply_upgrade(type)
	$UpgradePanel.visible = false
	get_parent().get_node("GameManager").upgrade_selected() 
	
	
func _on_damage_pressed() -> void:
	choose_upgrade("damage")

func _on_speed_pressed() -> void:
	choose_upgrade("speed")

func _on_hp_pressed() -> void:
	choose_upgrade("hp")

func _on_growth_control_pressed() -> void:
	choose_upgrade("growth_control")
