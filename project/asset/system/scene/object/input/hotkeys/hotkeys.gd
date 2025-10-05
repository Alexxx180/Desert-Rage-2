extends Node

signal feedback()
signal strength_input(power: float)

@export var fixed: bool = false
@export var actions: ActionButtonComplex

@onready var switch: Node = $switch

func build_caption(act: int) -> String:
	return actions.action if act == 0 else str(actions.action, "_", act)

func listen_events(acts: ActionButtonGroup) -> void:
	for act in acts.group:
		var key: String = build_caption(act.id)
		match act.state:
			ActionButton.STATE.TOGGLED: switch.touch(Input.is_action_just_pressed(key))
			ActionButton.STATE.RELEASED: switch.touch(Input.is_action_just_released(key))
			ActionButton.STATE.PRESSED: switch.press(not fixed and act.power, key)

func listen_groups() -> void:
	var i: int = len(actions.complex)
	while switch.timed and (i > 0):
		i -= 1
		listen_events(actions.complex[i])
	switch.calculate_power(fixed)

func listen() -> bool:
	switch.reset()
	listen_groups()
	switch.give_feedback()
	return switch.timed
