extends Button

@export var image: String = ""

@onready var equipment: ProgressBar = $equipment
@onready var base: ProgressBar = $equipment/base
@onready var number: Label = $number
@onready var icons: Label = $number/icon
@onready var BASE_MAX: int = int(base.max_value)

var equipped: bool = false
var stats_text: String
var equipments: int = 0

func _ready() -> void:
	icons.text = image
	stats_text = text

func set_base(stat: int) -> void:
	_set_base_value(stat)

func add_equip(add: int) -> void:
	var value: int = int(base.value)
	_set_equipment_value(value + add)

func _set_equipment_value(value: int) -> void:
	equipments = value
	if equipped: equipment.value = value

func _set_base_value(value: int) -> void:
	base.value = value
	number.text = str(value)
	text = stats_text
	if not equipped:
		text += " (%d)" % equipments

func _set_view_values(based: int, equip: int) -> void:
	equipment.value = equip
	base.max_value = based

func set_view_type(mode: bool) -> void:
	equipped = mode
	if equipped:
		_set_view_values(int(equipment.max_value), 0)
	else:
		_set_view_values(BASE_MAX, equipments)
	_set_base_value(int(base.value))
