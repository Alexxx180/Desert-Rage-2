extends VBoxContainer

signal show_help_button()

var help: String = "disappear"

@onready var animation: AnimationTree = $animation
"""
@onready var _acts = {
	"movement": $movement, "hill": $hill,
	"jumping": $jumping, "pushing": $pushing
}
#"""

func make_progress(hint: String, act: String) -> void:
	animation.set("parameters/hints/transition_request", hint)
	animation.set("parameters/%s/transition_request" % hint, act)

func toggle_hints() -> void:
	#pass
	animation.set("parameters/help/transition_request", "full")
	var none: String = "disappear"
	
	help = "appear" if help == none else none
	animation.set("parameters/full/transition_request", help)
		
	#print(animation.get("parameters/help/current_state"))
	
	#animation.set("parameters/%s/transition_request" % hint, act)

func set_progress() -> void:
	print("OH, NO")

func done_progress() -> void:
	show_help_button.emit()
