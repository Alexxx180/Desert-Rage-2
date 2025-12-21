extends Button

class_name StatusPoints

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

var jars: Array[int]: get = get_jars
var cells: Array[int] = []
var inventory: Node
# var hero: String

func get_jars() -> Array[int]: return []

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)

func set_inventory(hero: CharacterBody2D) -> void:
	inventory = hero.to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag and cell.get_item().id in jars
	
func _drop_data(_pos: Vector2, cell: Variant) -> void:
	if cell.use_item() == 0:
		cell.image.holder = null
