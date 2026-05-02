extends VBoxContainer

@onready var heroes: Array[HFlowContainer] = [$ray, $rock]
@onready var bank: VBoxContainer = $bank

func connect_opened(opened: Button, ability: VBoxContainer) -> void:
	if opened:
		opened.focus_entered.connect(func(): ability.show())
		opened.focus_exited.connect(func(): ability.hide())
		opened.mouse_entered.connect(func(): ability.show())
		opened.mouse_exited.connect(func(): ability.hide())

func connect_ability(ability: BoxContainer) -> void:
	for hero in heroes:
		var path: NodePath = NodePath(ability.name)
		if hero.has_node(path):
			connect_opened(hero.get_node(path), ability) #  + "/opened"

func connect_category(category: VBoxContainer) -> void:
	for ability in category.get_children():
		connect_ability(ability)
"""
func _ready() -> void:
	for category in bank.get_children():
		connect_category(category)
"""
