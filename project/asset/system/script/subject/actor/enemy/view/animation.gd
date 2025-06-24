extends AdvancedCharacterAnimation

func _ready() -> void: _direct()

func direct_animations() -> Array[String]:
	return ["rolling"]

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: request("enemy", "active")
	else: request("enemy", "passive")
	return turned
