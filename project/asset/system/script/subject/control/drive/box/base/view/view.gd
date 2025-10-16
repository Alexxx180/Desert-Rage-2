extends Node2D

@onready var stand: Sprite2D = $stand
"""
@onready var heroes: Dictionary = {
	"ray": $ray_profile, "rock": $rock_profile }

var _name: String = "ray"

func enable_sync(seat: Node, hero: CharacterBody2D) -> void:
	_name = hero.name
	var view: Node2D = heroes[hero.name]
	view.visible = true
	hero.view.animation.effect.sync_anim.connect(sync_anim)
	var p: AnimatedSprite2D = hero.view.profile
	sync_anim(p.animation, p.frame)
	# view.enable_sync(seat, hero)

func disable_sync(seat: Node, hero: CharacterBody2D) -> void:
	var view: Node2D = heroes[hero.name]
	view.visible = false
	hero.view.animation.effect.sync_anim.disconnect(sync_anim)
	# view.disable_sync(seat, hero)

func sync_anim(animation: String, frame: int) -> void:
	# print("received animation: ", animation, " - and frame: ", frame)
	heroes[_name].animation = animation
	heroes[_name].frame = frame
"""
