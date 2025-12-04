extends VBoxContainer

@onready var body: HBoxContainer = $body
@onready var meter: HBoxContainer = $meter

func set_hide_xp() -> void:
	body.set_hide_xp()
	body.timer.timeout.connect(meter.hide)

func set_show_xp(group_xp: Node) -> void:
	body.set_show_xp(group_xp)
	meter.new_score(group_xp)	

func update_meter(time: float, maximum: float) -> void:
	body.multiplier.update_meter(time, maximum)
	meter.update_color(body.multiplier.visible)

func update_multiplier(scored: float) -> void:
	body.multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(body.space.score.new_level_up)
	set_hide_xp()
	set_show_xp(group_xp)
