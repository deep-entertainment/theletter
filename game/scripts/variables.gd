extends Node

var state = {
	"has_turned_off_notification" : false,
	"is_searching_for_ref" : false,
	"is_starting_monologue": false,
	"had_monologue": false,
	"needs_to_check_clock": false,
	"needs_to_check_attendance": false,
	"needs_account_password": false,
	"has_account_password": false,
	# Scene 2
	"started_ice_adventure": false,
	"in_ice_adventure": false,
	"has_stick": false,
	# Scene 3
	"andy_is_at_bar": false,
	"phil_is_at_bar": false,
	"andy_is_back": false,
	"phil_is_back": false,
	# Scene 4
	"spoke_with_receptionist": false,
	"spoke_with_infocomm": false,
	"should_wait": false,
	"did_wait": false,
}

var scene_cinematograph: Cinematograph

var hotspots_disabled = false
