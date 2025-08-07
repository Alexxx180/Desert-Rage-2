extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p]

func take_effect(mark: Tick) -> void:
	print("LUNGE!")

func tick(mark: Tick) -> int:
	print("TRIPLE PUNCH START")
	return basis.tick(mark, self)
