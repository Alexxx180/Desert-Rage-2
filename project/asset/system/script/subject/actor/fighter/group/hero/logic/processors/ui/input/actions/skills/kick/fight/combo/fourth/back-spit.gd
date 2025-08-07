extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p, k]

func take_effect(mark: Tick) -> void:
	print("BACK-SPIT KICK!")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
