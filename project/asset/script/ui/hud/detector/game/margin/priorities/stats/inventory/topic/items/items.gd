extends HFlowContainer

@onready var slots: Array[Node] = get_children()

var _title: HBoxContainer
var title: HBoxContainer:
	get: return Def.lazy(self, _title, Def.title, &"title")

# func _ready() -> void:
	# for i in range(0, HeroInventory.SLOTS): slots[i].slot = i
