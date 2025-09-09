extends Node

signal feedback()
signal strength_input(power: float)

@export var delay: bool = false
"""
@onready var timer: Timer = $timer  # delay implementation
func _ready() -> void: timer.timeout.connect(give_feedback)
func restart_delay() -> void: if not timer.is_stopped(): timer.start()
# """

const FIXED_POWER: float = 1.0

var actions: ActionButtonComplex
var power: Vector2
var fixed: bool = false

func give_feedback() -> void: feedback.emit()
func build_caption(act: int) -> String:
	var caption: String = actions.action if act == 0 else str(actions.action, "_", act)
	# print("CAPTION: ", caption)
	return caption

func set_strength(strength: float) -> void:
	power += Vector2(strength, 1)

func linked_events(acts: ActionButtonGroup) -> bool:
	var result: bool = true
	for act in acts.group:
		var caption: String = build_caption(act.id)
		match act.state:
			ActionButton.ActionButtonState.TOGGLED:
				result = result and Input.is_action_just_pressed(caption)
				if act.power: set_strength(FIXED_POWER)
			ActionButton.ActionButtonState.RELEASED:
				result = result and Input.is_action_just_released(caption)
				if act.power: set_strength(FIXED_POWER)
			_:
				result = result and Input.is_action_pressed(caption)
				if act.power: set_strength(FIXED_POWER if fixed else Input.get_action_strength(caption))
	return result

func listen(event: InputEvent) -> bool:
	power = Vector2.ZERO
	var result: bool = false
	var i: int = len(actions.complex)
	while (not result) and (i > 0):
		i -= 1
		result = linked_events(actions.complex[i])
	if power != Vector2.ZERO:
		strength_input.emit(power.x / power.y)
	if result: give_feedback() # delay implementation
	if actions.passthru: return false
	return result
