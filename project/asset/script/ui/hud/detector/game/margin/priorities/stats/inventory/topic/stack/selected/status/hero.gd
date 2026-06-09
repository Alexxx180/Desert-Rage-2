extends MarginContainer

@onready var bag: Button = $bag
@onready var health: Button = $health
@onready var ability: Button = $ability

func _ready() -> void: bag.hero = name
