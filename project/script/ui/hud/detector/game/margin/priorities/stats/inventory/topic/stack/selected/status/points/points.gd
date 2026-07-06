extends Button

class_name StatusPoints

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

var cells: Array[int] = []
var inventory: Node

func key() -> String: return "h"

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)

func set_inventory(hero: CharacterBody2D) -> void:
	inventory = hero.to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag and inventory.logic.sorting.fillable(cell, key())
	
func _drop_data(_pos: Vector2, cell: Variant) -> void:
	if cell.drag.ui.logic.sorting.use_as_slot(cell.slot) == 0:
		cell.drag.ui.reset_holder()
