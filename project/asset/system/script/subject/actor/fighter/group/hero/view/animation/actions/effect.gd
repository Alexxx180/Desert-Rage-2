extends Node

signal sync_anim(animation: String, frame: int)
signal close_damage(points: int)

enum { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3 }

var moves: Node
var stats: Array

func set_stats(next: Array) -> void: stats = next

func set_damage(multiplier: float = 1) -> void:
	close_damage.emit(5)# * multiplier) # stats[POWER]

func set_position(proportion: float) -> void:
	moves.hero.to.act.teleport.move(proportion)
	sync_animation()

func sync_animation() -> void:
	var view: AnimatedSprite2D = moves.hero.view.profile # print("SYNCED animation: ", view.animation, " - and frame: ", view.frame)
	sync_anim.emit(view.animation, view.frame)
