extends Node

@onready var levels: Node = $levels
@onready var check: Node = $check
@onready var teleport: Node = $teleport

var lay: Node

func setup(_lay: Node) -> void:
	lay = _lay
	teleport.fill(lay) # check.set_layers(lay)
	levels.connect_levels(lay.tags.layer.curtain, check)
	SessionStats.assign(lay.tags.layer.get_parent().name.trim_prefix("map"))

func transit(hero: CharacterBody2D) -> void:
	# if !check.transitable(map): return
	lay.tags.from_pos(hero.position)
	match lay.border.from_pos(hero.position).context.atlas:
		Vector2i(4, 0):
			teleport.transit(hero, lay) # Vector2i(2, 0), Vector2i(2, 1): #	levels.credits()
		_: levels.elevate(lay)
