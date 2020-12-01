extends Control

func lets_begin():
	$NormalCamera.current = true
	get_tree().change_scene("res://scenes/BensRoom.tscn")
