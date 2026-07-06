extends Node

const DAMAGE: int = 5

@onready var press: Node = get_parent()
var is_near: bool:
	get: return press.standing
var small_circle: FightRange = FightRange.new()

func take_effect() -> void:
	small_circle.hit(DAMAGE)
	# box logic
