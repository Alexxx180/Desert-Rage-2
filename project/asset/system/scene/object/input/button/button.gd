extends Node

signal feedback()
signal strength_input(power: float)

@export var fixed: bool = false
@export var actions: ActionButtonComplex

@onready var switch: Node = $switch

func build_caption(act: int) -> String:
	return actions.action if act == 0 else str(actions.action, "_", act)

func listen_events(acts: ActionButtonGroup, impulsed: bool) -> void:
	switch.reset_time(true)
	switch.reset_power()
	var key: String
	for act in acts.group:
		key = build_caption(act.id)
		match act.state:
			ActionButton.STATE.TOGGLED: switch.touch(Input.is_action_just_pressed(key))
			ActionButton.STATE.RELEASED: switch.touch(Input.is_action_just_released(key))
			ActionButton.STATE.PRESSED: switch.touch(Input.is_action_pressed(key))
	if switch.timed: switch.set_power(fixed or impulsed, key)

func listen_groups() -> void:
	switch.reset_time(false)
	var i: int = len(actions.complex)
	while (not switch.timed) and (i > 0):
		i -= 1
		listen_events(actions.complex[i], not actions.power)

func listen() -> bool:
	listen_groups()
	switch.give_feedback(fixed)
	return switch.timed
