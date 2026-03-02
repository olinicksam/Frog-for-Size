extends Area2D

@export var shrink_amount := 0.5 #how much player shrinks

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.scale -= Vector2.ONE * shrink_amount
		if body.scale.x < 0.5:
			body.scale = Vector2(0.5,0.5) #minimum size
		SFXManager.play_pickup()
		queue_free() #removes jar
