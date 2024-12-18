@tool
extends BehaviorDecorator

class_name BehaviorInverter

"""
	Decorator Node. Inverter does not change running
	responses. Returns OK on FAILED, FAILED on OK.
"""
func tick(mark: Tick) -> int:
	for child in get_children():
		var result: int = child._execute(mark)
		match result:
			OK: return FAILED
			FAILED: return OK
			_: return result

	return OK
