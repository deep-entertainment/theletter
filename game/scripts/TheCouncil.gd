extends Control

var targets = {
	"start": Vector2(465,764),
	"waiting": Vector2(304,740),
	"infocomm": Vector2(742,931)
}

func _ready():
	Variables.scene_cinematograph = $Cinematograph
	$Cinematograph.set_scenes([
		"4d_reception",
		"4d_poster",
		"4d_waitingarea",
		"4d_infocomm",
		"4d_doors",
		"4d_receptionist",
		"4_receptionista",
		"4_infocomm",
		"4_receptionistb",
		"4_receptionistc",
		"4_thoughts",
	])
	$Ben.position = targets.start
	$Ben.target = targets.start
	$Ben/Animation.animation = "idle"
	$Ben/Animation.frame = 0
	$Ben/Animation.flip_h = true
	
func _process(_delta):
	for hotspot in $Hotspots.get_children():
		(hotspot as TextureButton).disabled = Variables.hotspots_disabled


func _on_Reception_pressed():
	$Hotspots/Reception.release_focus()
	$Cinematograph.play_scene("4d_reception")


func _on_Receptionist_pressed():
	$Hotspots/Receptionist.release_focus()
	if !Variables.state['spoke_with_receptionist']:
		Variables.state['spoke_with_receptionist'] = true
		$Receptionist.play("speaking")
		$Cinematograph.play_scene("4_receptionista")
	elif Variables.state['spoke_with_infocomm']:
		$Receptionist.play("speaking")
		$Cinematograph.play_scene("4_receptionistb")			
	else:
		$Cinematograph.play_scene("4d_receptionist")

func _on_Poster_pressed():
	$Hotspots/Poster.release_focus()
	$Cinematograph.play_scene("4d_poster")

func _on_Doors_pressed():
	$Hotspots/Doors.release_focus()
	if Variables.state["did_wait"]:
		$Animations.play("last walk")
	else:
		$Cinematograph.play_scene("4d_doors")

func to_revelations():
	get_tree().change_scene("res://scenes/Revelations.tscn")

func _on_Infocomm_pressed():
	$Hotspots/Infocomm.release_focus()
	if !Variables.state['spoke_with_receptionist'] or Variables.state['spoke_with_infocomm']:
		$Cinematograph.play_scene("4d_infocomm")
	else:
		$Ben.set_target(targets.infocomm)


func _on_WaitingArea_pressed():
	$Hotspots/WaitingArea.release_focus()
	if !Variables.state['should_wait']:
		$Cinematograph.play_scene("4d_waitingarea")
	else:
		$Ben.set_target(targets.waiting)


func _on_Ben_target_reached(target: Vector2):
	if target == targets.start:
		$Ben/Animation.flip_h = true
	elif target == targets.waiting:
		$Animations.play("waiting")
	elif target == targets.infocomm and !Variables.state["spoke_with_infocomm"]:
		Variables.state['spoke_with_infocomm'] = true
		$Cinematograph.play_scene("4_infocomm")

func ben_standup(standup:bool):
	$Ben/Animation.flip_h = true
	$Ben/Animation.play("standup", !standup)

func ben_wait():
	$Ben/Animation.play("sit")
	$Ben/Animation.flip_h = true
	
func to_doors():
	$Ben.set_target(targets.infocomm)

func _on_Cinematograph_finished(reel: String):
	if reel == "4_thoughts":
		Variables.state["did_wait"] = true
	elif reel == "4_infocomm":
		$Ben.set_target(targets.start)
	elif reel == "4_receptionista":
		$Receptionist.play("idle")
	elif reel == "4_receptionistb":
		$Animations.play("receptionist glitch")
	elif reel == "4_receptionistc":
		$Receptionist.play("idle")
		Variables.state['should_wait'] = true
