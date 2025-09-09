extends Node

signal feedback()
signal strength_input(power: float)

@export var delay: bool = false
@onready var timer: Timer = $timer

var actions: ActionButtonComplex
var power: Vector2

func _ready() -> void:
	timer.timeout.connect(give_feedback)

func give_feedback() -> void: feedback.emit()
func restart_delay() -> void: if not timer.is_stopped(): timer.start()

func build_caption(act: int) -> String:
	var caption: String = actions.action if act == 0 else str(actions.action, "_", act)
	# print("CAPTION: ", caption)
	return caption

func check_strength(is_power: bool, caption: String) -> void:
	if is_power:
		Input.get_action_strength(caption)

func linked_events(acts: ActionButtonGroup) -> bool:
	var result: bool = true
	for act in acts.group:
		var caption: String = build_caption(act.id)
		match act.state:
			ActionButton.ActionButtonState.TOGGLED:
				result = result and Input.is_action_just_pressed(caption)
			ActionButton.ActionButtonState.RELEASED:
				result = result and Input.is_action_just_released(caption)
			_:
				result = result and Input.is_action_pressed(caption)
				check_strength(act.state, caption)
	return result

func listen(event: InputEvent) -> bool:
	power = Vector2.ZERO
	var result: bool = false
	var i: int = len(actions.complex)
	while (not result) and (i > 0):
		i -= 1
		result = linked_events(actions.complex[i])
	if result:
		if delay: pass # timer.start()
		else: give_feedback()
	if power != Vector2.ZERO:
		strength_input.emit(power.x / power.y)
		return false
	return result
