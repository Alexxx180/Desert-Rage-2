extends Node

@onready var platform: Node = $platform

func teleport(next: Vector2, action: String = "jump") -> void:
	print("START TELEPORTING: ", platform.target.position + platform.target.size)
	platform.set_target_stand(next)
	platform.hero.to.moves.jump.start(action)

func dash(force: Vector2, action: String = "jump") -> void:
	print("DASH TO GROUND. ")
	teleport(platform.hero.position + force, action)

func move(proportion: float) -> void:
	platform.sync_hero_pos(proportion)
	if platform.is_landed(proportion):
		platform.decide_jump()
		platform.hero.to.moves.jump.end()
