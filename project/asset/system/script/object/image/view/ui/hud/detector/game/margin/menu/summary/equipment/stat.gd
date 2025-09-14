extends VBoxContainer

@onready var count: Array[Label] = [$description/number, $description/alternate]
@onready var base: ProgressBar = $margin/base
@onready var equipment: ProgressBar = $margin/equipment

@onready var BASE_MAX: int = base.max_value

var equipped: bool = false

func set_base(stat: int) -> void:
	var addon: int = equipment.value - base.value
	base.value = stat
	set_equip(stat, stat if addon <= 0 else (stat + addon))

func set_equip(stat: int, next: int) -> void:
	equipment.value = next
	_set_counts([next, stat] if equipped else [stat, next])

func add_equip(add: int) -> void:
	set_equip(base.value, base.value + add)

func _set_counts(stats: Array) -> void:
	for i in range(0, len(count)):
		count[i].text = str(stats[i])

func _set_base_count(value: int, stats: Array) -> void:
	base.max_value = value
	_set_counts(stats)

func set_view_type(with: bool) -> void:
	equipped = with
	if with:
		_set_base_count(equipment.max_value, [equipment.value, base.value])
	else:
		_set_base_count(BASE_MAX, [base.value, equipment.value])
	equipment.visible = equipped
	
