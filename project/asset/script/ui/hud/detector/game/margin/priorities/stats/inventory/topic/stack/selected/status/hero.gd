extends MarginContainer

@export var is_bag: bool = false

@onready var health: Button = $health
@onready var ability: Button = $ability
var bag: Button

func _ready() -> void: 
	if is_bag:
		bag = preload("res://asset/scene/ui/hud/detector/game/menu/inventory/status/shared/bag.tscn").instantiate()
		bag.hero = name
		add_child(bag)
