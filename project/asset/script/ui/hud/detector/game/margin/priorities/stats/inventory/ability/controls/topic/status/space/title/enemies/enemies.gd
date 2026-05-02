extends Control

@export var fixed: bool = false
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

func _update_pause() -> Variant: return Works.upload_hold(self, "holder", _pause, Defaults.now.pause, "pause")

var _pause: HBoxContainer = null
var pause: HBoxContainer:
	get: return _update_pause()

var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get: return Works.upload_hold(self, "space", _enemy, Defaults.now.enemy, "enemy")

var _slots: ColorRect = null
var slots: ColorRect:
	get: return Works.upload_at(self, status, _slots, Defaults.now.slots, "slots")

func _ready() -> void:
	$holder.mouse_entered.connect(_update_pause) #status.xp.set_fixed(fixed)
