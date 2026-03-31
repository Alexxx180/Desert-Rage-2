extends Control

@export var fixed: bool = false
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

func _update_pause() -> void:
	if _pause == null:
		_pause = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/pause.tscn").instantiate()
		add_child(_pause)
		remove_child($holder)

var _pause: HBoxContainer = null
var pause: HBoxContainer:
	get:
		_update_pause()
		return _pause

var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get:
		if _enemy == null:
			_enemy = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/enemy/enemy.tscn").instantiate()
			var space: Control = $space
			space.add_sibling(_enemy)
			remove_child(space)
		return _enemy

var _slots: ColorRect = null
var slots: ColorRect:
	get:
		if _slots == null:
			_slots = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/slots.tscn").instantiate()
			status.add_sibling(_slots)
		return _slots

func _ready() -> void:
	$holder.mouse_entered.connect(_update_pause) #status.xp.set_fixed(fixed)
