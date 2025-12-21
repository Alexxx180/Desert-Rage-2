extends Button

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

@export var jars: Array[int] = [1, 2, 6, 7, 8, 9, 10, 11, 12]

var cells: Array[int] = []
var inventory: Node
var hero: String

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)

func set_inventory(group: Node2D) -> void: inventory = group.get(hero).to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag and cell.get_item().id in jars
	
func _drop_data(_pos: Vector2, cell: Variant) -> void:
	if cell.use_item() == 0:
		cell.image.holder = null

# func switch() -> void: switch_bags.emit(hero)
# func _ready() -> void: pressed.connect(switch)
