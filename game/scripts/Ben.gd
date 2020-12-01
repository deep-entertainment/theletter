extends KinematicBody2D
signal target_reached

export (int) var speed = 300

var target = Vector2()
var velocity = Vector2()
var sent_target_reached = false

func _physics_process(_delta):
	velocity = position.direction_to(target) * speed
	# look_at(target)
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
	else:
		if !sent_target_reached:
			Variables.hotspots_disabled = false
			emit_signal("target_reached", target)
			sent_target_reached = true
		if ($Animation.animation == "left"):
			$Animation.play("idle")
	
func set_target(p_target: Vector2):
	Variables.hotspots_disabled = true
	if (position.x < p_target.x):
		$Animation.flip_h = true
	else:
		$Animation.flip_h = false
	$Animation.play("left")
	sent_target_reached = false
	target = p_target

func run_animation(p_animation: String):
	$Animation.play(p_animation)

func set_fliph(p_fliph: bool):
	$Animation.flip_h = p_fliph
