extends Control
	
var girls_completed = 0
var girls_in_fear = 0

var targets = {
	"start": Vector2(904,916),
	"ice": Vector2(614,907)
}

func _ready():
	Variables.scene_cinematograph = $Cinematograph
	$Cinematograph.set_scenes([
		"2d_children_common",
		"2d_longstick_common",
		"2d_longstick_puzzle",
		"2d_plantingbed",
		"2d_city",
		"2d_wall",
		"2d_trees",
		"2_entrya",
		"2_entryb",
		"2_entryc",
		"2_icea",
		"2_iceb",
		"2_icec",
		"2_iced",
	])
	$Ben.position = targets.start
	$Ben.target = targets.start
	$Ben/Animation.animation = "idle"
	$Ben/Animation.frame = 0
	$Ben/Animation.flip_h = false

func _process(_delta):
	for hotspot in $Hotspots.get_children():
		(hotspot as TextureButton).disabled = Variables.hotspots_disabled
	$Cinematograph.set_position($Camera2D.position)

func disableHotspots(p_disabled: bool):
	Variables.hotspots_disabled = p_disabled

func toStart():
	$Ben.set_target(targets.start)

func _on_Cinematograph_finished(scene: String):
	if scene == "2_entrya":
		$Animations.play("Fadein")
	elif scene == "2_entryb":
		$Animations.play("kids")
	elif scene == "2d_longstick_puzzle":
		$Stick.visible = false
		$Hotspots.remove_child($Hotspots/Stick)
		Variables.state['has_stick'] = true
	elif scene == "2_icea":
		$Ben.visible = true
		$BenSitting.visible = false
		$Ben.set_target(targets.ice)
		Variables.hotspots_disabled
	elif scene == "2_iceb":
		$Ben.set_target(targets.start)
		$Girl1/Girl.play("lyingdown")
		$Girl2/Girl.play("lyingdown")
	elif scene == "2_icec":
		$Animations.play("Text from Phil")
	elif scene == "2_iced":
		$Animations.play("blackout")

func change_to_pub():
	get_tree().change_scene("res://scenes/Pub.tscn")

func _on_PlantingBed_pressed():
	$Hotspots/PlantingBed.release_focus()
	$Cinematograph.play_scene("2d_plantingbed")


func _on_Wall_pressed():
	$Hotspots/Wall.release_focus()
	$Cinematograph.play_scene("2d_wall")


func _on_City_pressed():
	$Hotspots/City.release_focus()
	$Cinematograph.play_scene("2d_city")


func _on_Tree_pressed():
	$Hotspots/Tree.release_focus()
	$Cinematograph.play_scene("2d_trees")


func _on_Stick_pressed():
	if Variables.state['in_ice_adventure']:
		$Cinematograph.play_scene("2d_longstick_puzzle")
	else:
		$Cinematograph.play_scene("2d_longstick_common")


func _on_SkatingGirls_pressed():
	if !Variables.state['started_ice_adventure']:
		Variables.state['started_ice_adventure'] = true
		Variables.hotspots_disabled=true
		$Shader.mouse_default_cursor_shape = CURSOR_WAIT
		$Cinematograph.set_waiting_visible(true)
	if Variables.state['has_stick']:
		$Animations.play("Rescue")
	elif Variables.state['in_ice_adventure']:
		$Cinematograph.play_scene("2d_children_common")

func check_girls_completed():
	if girls_completed == 2:
		$Shader.mouse_default_cursor_shape = CURSOR_ARROW
		$Girl1/Animation.play("Getting in fear")
		$Girl2/Animation.play("Getting in fear")
		$Cinematograph.set_waiting_visible(false)

func check_girls_in_fear():
	if girls_in_fear == 2:
		$Cinematograph.play_scene("2_icea")
	
func _on_Girl_animation_finished(anim_name):
	if anim_name=="Skiing" and Variables.state['started_ice_adventure']:
		girls_completed = girls_completed + 1
		check_girls_completed()
	elif Variables.state['started_ice_adventure']:
		girls_in_fear = girls_in_fear + 1
		check_girls_in_fear()

func _on_Girl1_animation_finished(anim_name):
	if !Variables.state['started_ice_adventure'] and anim_name == "Skiing":
		$Girl1/Animation.play(anim_name)
	else:
		_on_Girl_animation_finished(anim_name)

func _on_Girl2_animation_finished(anim_name):
	if !Variables.state['started_ice_adventure'] and anim_name == "Skiing":
		$Girl2/Animation.play(anim_name)
	else:
		_on_Girl_animation_finished(anim_name)


func _on_Ben_target_reached(target: Vector2):
	if target == targets.ice:
		$Animations.play("Ben Ice")
	elif target == targets.start and Variables.state['started_ice_adventure']:
		Variables.hotspots_disabled = false
		Variables.state['in_ice_adventure'] = true
		
