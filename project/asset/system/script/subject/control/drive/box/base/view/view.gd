extends Node2D

@onready var stand: Sprite2D = $stand
@onready var heroes: Dictionary = {
	"ray": $ray_profile, "rock": $rock_profile }

var _name: String = "ray"

func enable_sync(seat: Node, hero: CharacterBody2D) -> void:
	_name = hero.name
	var view: Node2D = heroes[hero.name]
	view.visible = true
	hero.view.animation.effect.sync.connect(sync)
	# view.enable_sync(seat, hero)

func disable_sync(seat: Node, hero: CharacterBody2D) -> void:
	var view: Node2D = heroes[hero.name]
	view.visible = false
	hero.view.animation.effect.sync.disconnect(sync)
	# view.disable_sync(seat, hero)

func sync(animation: String, frame: int) -> void:
	heroes[_name].animation = animation
	heroes[_name].frame = frame
