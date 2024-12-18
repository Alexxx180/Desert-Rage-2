@tool
extends BehaviorTreeBase

class_name BehaviorDecorator

func warn() -> String:
	return "should have exactly one child"

func _tick(mark: Tick) -> int:
	if not get_child_count() == 1:
		push_error(name + " is a decorator and " + warn())
	return super._tick(mark)

func _notification(code: int) -> void:
	if code in [NOTIFICATION_PARENTED, NOTIFICATION_UNPARENTED]:
		update_configuration_warnings()

func _get_configuration_warning() -> String:
	if get_child_count() == 1: return ""
	return "Decorators " + warn()
