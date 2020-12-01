extends Control

var targets = {
	"fireplace": Vector2(1391,861),
	"fireplace_exit": Vector2(1619, 965),
	"start": Vector2(1075,947),
	"cupboard": Vector2(895,736),
	"communicator": Vector2(983,729)
}

export (float) var reverb_intensity = 0 setget reverb_set, reverb_get

func _ready():
	Variables.scene_cinematograph = $Cinematograph
	$Cinematograph.set_scenes([
		"1d_photo_judith",
		"1d_photo_family",
		"1d_photo_gang",
		"1d_photo_phil",
		"1d_photo_vacation",
		"1d_cushion",
		"1d_clock_common",
		"1d_clock_parkadmittance",
		"1d_letter_common",
		"1d_folders",
		"1d_safe",
		"1d_door_back",
		"1d_door_right",
		"1d_carpet",
		"1d_door_front",
		"1d_plants_common",
		"1d_plants_password",
		"1_communicator_notification",
		"1_thelettera",
		"1_theletterb",
		"1_checkedtheclock",
		"1_askpassword",
		"1_havepassword",
	])
	$Ben.position = targets.fireplace
	$Ben.target = targets.fireplace
	$Ben/Animation.animation = "standup"
	$Ben/Animation.frame = 0
	$Ben/Animation.flip_h = true

func _process(_delta):
	for hotspot in $Hotspots.get_children():
		(hotspot as TextureButton).disabled = Variables.hotspots_disabled

func disableHotspots(p_disabled: bool):
	Variables.hotspots_disabled = p_disabled

func startMusic():
	$Music.playing = true

func reverb_set(value: float):
	reverb_intensity = value
	(AudioServer.get_bus_effect(AudioServer.get_bus_index("music"), 0) as AudioEffectReverb).wet = reverb_intensity
	(AudioServer.get_bus_effect(AudioServer.get_bus_index("sound"), 0) as AudioEffectReverb).wet = reverb_intensity

func reverb_get():
	return reverb_intensity

# Communicator
		
func _on_Communicator_pressed():
	$Hotspots/Communicator.release_focus()
	if !Variables.state["has_turned_off_notification"]:
		$Ben.set_target(targets.communicator)
	elif Variables.state["needs_to_check_clock"] and not Variables.state["has_account_password"]:
		$Cinematograph.play_scene("1_askpassword")
	elif Variables.state["needs_to_check_attendance"] and not Variables.state["needs_account_password"]:
		Variables.state["needs_account_password"] = true
	elif Variables.state["has_account_password"]:
		$Cinematograph.play_scene("1_havepassword")

# Cupboard

func _on_Cupboard_pressed():	
	$Hotspots/Cupboard.release_focus()
	if !Variables.state["has_turned_off_notification"] or Variables.state["had_monologue"]:
		$Cinematograph.play_scene('1d_folders')
	elif $Ben.position.distance_to(targets.cupboard) > 5:
		$Ben.set_target(targets.cupboard)

func _Cupboard_action():
	$Cinematograph.play_scene("1_thelettera")

func _on_Cinematograph_finished(scene: String):
	if scene == "1_communicator_notification":
		$Communicator.play("warning")
		startMusic()
		Variables.state["is_searching_for_ref"] = true
	elif scene == "1_thelettera":
		Variables.state["is_searching_for_ref"] = false
		Variables.state["is_starting_monologue"] = true
		$Ben.set_target(targets.start)
	elif scene == "1_theletterb":
		Variables.state["is_starting_monologue"] = false
		Variables.state["had_monologue"] = true
		Variables.state["needs_to_check_clock"] = true
		$Animations.play("Ending the monologue")
	elif scene == "1_havepassword":
		$Shader.color = Color(0,0,0,1)
		get_tree().change_scene("res://scenes/ThePark.tscn")
		
# Ben

func _on_Ben_target_reached(target):
	if target == targets.cupboard:
		_Cupboard_action()
	elif target == targets.start and Variables.state["is_starting_monologue"]:
		$Animations.play("Starting the monologue")
	elif target == targets.communicator:
		Variables.state["has_turned_off_notification"] = true
		$Animations.play("Confirming Warning")

func exit_fireplace():
	$Ben.run_animation("idle")
	$Ben.set_target(targets.fireplace_exit)
	
func to_start():
	$Ben.set_target(targets.start)

func _on_PhotoFamily_pressed():
	$Hotspots/PhotoFamily.release_focus()
	$Cinematograph.play_scene("1d_photo_family")

func _on_PhotoGang_pressed():
	$Hotspots/PhotoGang.release_focus()
	$Cinematograph.play_scene("1d_photo_gang")

func _on_PhotoVacation_pressed():
	$Hotspots/PhotoVacation.release_focus()
	$Cinematograph.play_scene("1d_photo_vacation")

func _on_Clock_pressed():
	$Hotspots/Clock.release_focus()
	if Variables.state["needs_to_check_clock"]:
		$Cinematograph.play_scene("1_checkedtheclock")
		Variables.state["needs_account_password"] = true
	else:
		$Cinematograph.play_scene("1d_clock_common")

func _on_PhotoJudith_pressed():
	$Hotspots/PhotoJudith.release_focus()
	$Cinematograph.play_scene("1d_photo_judith")

func _on_DoorFront_pressed():
	$Hotspots/DoorFront.release_focus()
	$Cinematograph.play_scene("1d_door_front")

func _on_DoorBack_pressed():
	$Hotspots/DoorBack.release_focus()
	$Cinematograph.play_scene("1d_door_back")


func _on_DoorRight_pressed():
	$Hotspots/DoorRight.release_focus()
	$Cinematograph.play_scene("1d_door_right")
	
func _on_Plants_pressed():
	$Hotspots/Plants.release_focus()
	if Variables.state["needs_account_password"]:
		$Cinematograph.play_scene("1d_plants_password")
		Variables.state["has_account_password"] = true
	else:
		$Cinematograph.play_scene("1d_plants_common")

func _on_PhotoPhil_pressed():
	$Hotspots/PhotoPhil.release_focus()
	$Cinematograph.play_scene("1d_photo_phil")

func _on_Cushion_pressed():
	$Hotspots/Cushion.release_focus()
	$Cinematograph.play_scene("1d_cushion")

func _on_Carpet_pressed():
	$Hotspots/Carpet.release_focus()
	$Cinematograph.play_scene("1d_carpet")
