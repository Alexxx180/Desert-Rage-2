extends HBoxContainer

@onready var slot: Label = $slot
@onready var time: PanelContainer = $time

var _hits: HBoxContainer = null
var hits: HBoxContainer:
	get:
		if _hits == null:
			_hits = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/status/hits.tscn").instantiate()
			slot.add_sibling(_hits)
		return _hits

var _xp: Control = null
var xp: Control:
	get:
		if _xp == $xp:
			remove_child(_xp)
			_xp = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/topic/status/status/xp.tscn").instantiate()
			add_child(xp)
		return _xp

func update_meter(duration: float, mx: float) -> void: xp.update_meter(duration, mx)

func update_multiplier(score: float) -> void: xp.update_multiplier(score)

func set_xp_score(group_xp: Node) -> void: xp.set_xp_score(group_xp)

func finish() -> void: xp.finish()
