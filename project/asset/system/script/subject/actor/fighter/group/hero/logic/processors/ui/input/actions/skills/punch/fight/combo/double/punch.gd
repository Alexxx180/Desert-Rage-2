extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	return [p, p]

func take_effect(mark: Tick) -> void:
	print("DOUBLE PUNCH")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
