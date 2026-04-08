extends RayCast2D

@onready var pull: Area2D = $pull
@onready var ground: Area2D = $ground
@onready var whip: Area2D = $whip

enum { WHIP = 240, CHAINS = 177 }

func set_direction(direction: Vector2i) -> void:
	target_position = Defaults.DIRECTION * direction
	ground.target_position = target_position
	pull.position = target_position
	# -417 MAX for whip (chains)
# 3 слоя - противники / игрок / ящик / книга (зона) = Entity,
# плиты / телепортер / пружины /  (зона 2D) = Ground,
# рычаги / лёд / сундук (рейкаст) = Trigger
