extends Node

@export var main: String = "drag_up"
@export var events: Array[Array] = [
	[[true, 0], [false, 2]]
]

func build_caption(act: int) -> String:
	return main if act == 0 else str(main, "_", act)

func linked_events(actions: Array) -> bool:
	var result: bool = true
	for act in actions:
		var caption: String = build_caption(act[1])
		if act[0]:
			result = result and Input.is_action_pressed(caption)
		else:
			result = result and Input.is_action_just_released(caption)
	return result

func listen(event: InputEvent) -> bool:
	var result: bool = false
	var i: int = len(events)
	while (not result) and (i > 0):
		i -= 1
		result = linked_events(events[i])
	return result
