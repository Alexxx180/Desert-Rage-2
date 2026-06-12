extends Control

@export var fixed: bool = false
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

# func _update_pause() -> Variant: return Works.upload_hold(self, "holder", _pause, LoadBus.pause, "pause")

var _pause: HBoxContainer = null
var pause: HBoxContainer:
	get: return null # _update_pause()

var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get: return null # Works.upload_hold(self, "space", _enemy, LoadBus.enemy, "enemy")

var _slots: ColorRect = null
var slots: ColorRect:
	get: return null # Works.upload_at(self, status, _slots, LoadBus.slots, "slots")

#func _ready() -> void:
#	$holder.mouse_entered.connect(_update_pause) #status.xp.set_fixed(fixed)
