extends Area2D

#signal is_near(can_is_near: bool)
@onready var border: Node2D = $border
var _count: int = 0

func is_colliding(leader: Vector2, follow: Vector2) -> bool:
	return _count == HeroParty.COUNT and not border.is_colliding(leader.direction_to(follow))

func ready_to_deploy(hero: PhysicsBody2D) -> void:
	if not hero.is_in_group("enemy"):
		_count += 1
#		is_near.emit(_count == HeroParty.COUNT)

func hero_get_far_away(hero: PhysicsBody2D) -> void:
	if not hero.is_in_group("enemy"):
		_count -= 1
#		is_near.emit(_count == HeroParty.COUNT)
