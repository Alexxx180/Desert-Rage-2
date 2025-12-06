extends HBoxContainer

@onready var xp: VBoxContainer = $xp
@onready var time: PanelContainer = $time

func update_meter(time: float, mx: float) -> void: xp.update_meter(time, mx)

func update_multiplier(score: float) -> void: xp.update_multiplier(score)

func set_xp_score(group_xp: Node) -> void: xp.set_xp_score(group_xp)

func finish() -> void: xp.finish()
