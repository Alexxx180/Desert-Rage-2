extends VBoxContainer

@onready var heroes: Array[HFlowContainer] = [$ray, $rock]
@onready var bank: VBoxContainer = $bank

func connect_opened(opened: Button, ability: VBoxContainer) -> void:
	opened.focus_entered.connect(func(): ability.show())
	opened.focus_exited.connect(func(): ability.hide())
	opened.mouse_entered.connect(func(): ability.show())
	opened.mouse_exited.connect(func(): ability.hide())

func connect_ability(ability: VBoxContainer) -> void:
	for hero in heroes:
		if hero.has_node(NodePath(ability.name)):
			connect_opened(hero.get_node(ability.name + "/opened"), ability)

func connect_category(category: VBoxContainer) -> void:
	for ability in category.get_children():
		connect_ability(ability)

func _ready() -> void:
	for category in bank.get_children():
		connect_category(category)
