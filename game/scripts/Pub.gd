extends Control

var targets_phil = {
	"start": Vector2(1643,1093),
	"bar": Vector2(322,1061),
}

var targets_andy = {
	"start": Vector2(1051,1070),
	"bar": Vector2(211,1064)
}

func _ready():
	Variables.scene_cinematograph = $Cinematograph
	$Cinematograph.set_scenes([
		"3d_sign",
		"3d_photo",
		"3d_table",
		"3d_bar",
		"3d_crowd",
		"3d_bartender",
		"3_entrya",
		"3_entryb",
		"3_entryc",
		"3_andyisback",
		"3_philisback",
		"3_toast",
	])
	
	$Ben.position = Vector2(1226,1041)
	$Ben.target = Vector2(1226,1041)
	$Ben/Animation.animation = "idle"
	$Ben/Animation.frame = 1
	$Ben/Animation.flip_h = true
	
	$Phil.position = targets_phil.start
	$Phil.target = targets_phil.start
	
	$Phil/Animation.animation = "idle"
	$Phil/Animation.frame = 0
	$Phil/Animation.flip_h = false
	
	$Andy.position = targets_andy.start
	$Andy.target = targets_andy.start
	
	$Andy/Animation.animation = "idle"
	$Andy/Animation.frame = 0
	$Andy/Animation.flip_h = true

func _process(_delta):
	for hotspot in $Hotspots.get_children():
		(hotspot as TextureButton).disabled = Variables.hotspots_disabled

func to_council():
	get_tree().change_scene("res://scenes/TheCouncil.tscn")

func _on_Trisha_pressed():
	$Cinematograph.play_scene("3d_bartender")


func _on_Sign_pressed():
	$Cinematograph.play_scene("3d_sign")

func _on_Bar_pressed():
	$Cinematograph.play_scene("3d_bar")

func _on_Crowd_pressed():
	$Cinematograph.play_scene("3d_crowd")


func _on_Cinematograph_finished(reel: String):
	if reel == '3_entrya':
		$Andy.set_target(targets_andy.bar)
	elif reel == '3_entryb':
		$Phil.set_target(targets_phil.bar)		
	elif reel == '3_entryc':
		Variables.state['andy_is_back'] = true
		Variables.state['phil_is_back'] = true
		$Phil.set_target(targets_phil.start)
		$Andy.set_target(targets_andy.start)
	elif reel == '3_andyisback':
		$Cinematograph.play_scene("3_philisback")
	elif reel == '3_toast':
		$Animation.play("blackout")

func _on_Andy_target_reached(target: Vector2):
	if target == targets_andy.bar:
		$Cinematograph.play_scene("3_entryb")

func _on_BensPint_pressed():
	$Cinematograph.play_scene("3_toast")

func _on_Phil_target_reached(target: Vector2):
	if target == targets_phil.bar:
		$Cinematograph.play_scene("3_entryc")
	elif target == targets_phil.start and Variables.state['phil_is_back']:
		$PintJudith.visible = true
		$PintPhil.visible = true
		$Hotspots/BensPint.disabled = false
		$Phil/Animation.flip_h = false
		$PintAndy.visible = true
		$PintBen.visible = true
		$Cinematograph.play_scene("3_andyisback")
