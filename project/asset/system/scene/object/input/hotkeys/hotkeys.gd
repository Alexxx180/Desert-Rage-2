extends Node

signal feedback()

var actions: ActionButtonComplex

func build_caption(act: int) -> String:
	var caption: String = actions.action if act == 0 else str(actions.action, "_", act)
	print("CAPTION: ", caption)
	return caption

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
	return result

func listen(event: InputEvent) -> bool:
	var result: bool = false
	var i: int = len(actions.complex)
	while (not result) and (i > 0):
		i -= 1
		result = linked_events(actions.complex[i])
	if result: feedback.emit()
	return result
