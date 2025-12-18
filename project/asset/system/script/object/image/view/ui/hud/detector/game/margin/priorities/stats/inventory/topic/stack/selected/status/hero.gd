extends HFlowContainer

@onready var bag: Button = $bag
@onready var health: Button = $health
@onready var ability: Button = $ability

func _ready() -> void: bag.hero = name

func set_inventory(group: Node2D) -> void:
	bag.inventory = group.get(name).to.inventory
