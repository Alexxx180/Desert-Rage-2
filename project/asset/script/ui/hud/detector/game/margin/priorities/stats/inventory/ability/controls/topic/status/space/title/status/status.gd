extends HBoxContainer

@onready var slot: Label = $slot
@onready var time: PanelContainer = $time

var _hits: HBoxContainer = null
var hits: HBoxContainer:
	get:
		return null #  Works.upload(self, _hits, LoadBus.hits, "hits")

var _xp: Label = null
var xp: Label:
	get: return null # Works.upload(self, _xp, LoadBus.xp, "xp")

func update_meter(duration: float, mx: float) -> void: xp.update_meter(duration, mx)

func update_multiplier(score: float) -> void: xp.update_multiplier(score)

func set_xp_score(group_xp: Node) -> void: xp.set_xp_score(group_xp)

func finish() -> void: xp.finish()
