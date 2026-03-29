extends Control

@export var fixed: bool = false
@onready var space: Control = $space
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get:
		if _enemy == null:
			_enemy = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/enemy/enemy.tscn").instantiate()
			space.add_sibling(_enemy)
		return _enemy

var _slots: ColorRect = null
var slots: ColorRect:
	get:
		if _slots == null:
			_slots = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/slots.tscn").instantiate()
			status.add_sibling(_slots)
		return _slots

# func _ready() -> void: status.xp.set_fixed(fixed)
