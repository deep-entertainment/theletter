extends Control
class_name Cinematograph

signal finished

var scenes = {}
var currentScene = ""
var currentSceneAnimationIndex = 0

func _ready():
	for animation in $Player.get_animation_list():
		$Player.remove_animation(animation)
	$Subtitle.bbcode_text = ""
	$Subtitle.visible = false
	set_waiting_visible(false)

func set_scenes(scene_names: Array):
	for scene_name in scene_names:
		var length = 0
		while ResourceLoader.exists("res://cinematograph_reels/%s.%d.tres" % [scene_name, length]):
			length = length + 1
		scenes[scene_name] = length
	
func play_scene(p_scene: String):
	Variables.hotspots_disabled = true
	currentScene = p_scene
	currentSceneAnimationIndex = 0
	for animation in $Player.get_animation_list():
		$Player.remove_animation(animation)
	for index in range(0, scenes[currentScene]):
		$Player.add_animation(currentScene + "." + String(index), ResourceLoader.load("res://cinematograph_reels/" + currentScene + "." + String(index) + ".tres"))
	$Player.add_animation("_clean", ResourceLoader.load("res://cinematograph_reels/0.clean.tres"))
	$Player.play(currentScene + "." + String(currentSceneAnimationIndex))

func _process(_delta):
	if Input.is_action_just_released("ui_accept"):
		_on_Player_animation_finished("")

func _on_Player_animation_finished(anim_name):
	if anim_name != '_clean':
		$Skip.disabled = true
		$Skip.mouse_default_cursor_shape = CURSOR_ARROW
		set_waiting_visible(false)	
		currentSceneAnimationIndex = currentSceneAnimationIndex + 1
		if currentSceneAnimationIndex < scenes[currentScene]:
			$Player.play(currentScene + "." + String(currentSceneAnimationIndex))
		else:
			emit_signal("finished", currentScene)
			Variables.hotspots_disabled = false
			$Player.play("_clean")


func _on_Player_animation_started(_anim_name):
	if _anim_name != '_clean':
		$Skip.disabled = false
		$Subtitle.visible = true
		$Skip.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		set_waiting_visible(true)


func _on_Skip_pressed():
	if $Player.current_animation != '_clean':
		_on_Player_animation_finished("")

func set_waiting_visible(visible: bool):
	$Waiting.visible = visible
