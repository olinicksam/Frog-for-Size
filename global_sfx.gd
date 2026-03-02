extends Node2D


# Called when the node enters the scene tree for the first time.
func play_pickup():
	$PickupPlayer.play()

func play_win():
	$Win.play()
	
func play_lose():
	$Lose.play()
	
	
