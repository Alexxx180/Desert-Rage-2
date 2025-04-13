extends BehaviorSelector

@onready var hero: BehaviorAction = $hero
@onready var typed: BehaviorAction = $typed

func set_ost(music: Node) -> void:
	hero.set_ost(music)
	typed.set_ost(music)
