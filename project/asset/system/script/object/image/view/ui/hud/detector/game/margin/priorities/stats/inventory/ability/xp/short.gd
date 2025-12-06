extends VBoxContainer

@onready var body: HBoxContainer = $body
@onready var meter: HBoxContainer = $meter
@onready var timer: Timer = $timer

func set_fixed(state: bool) -> void:
	body.space.score.fixed = state
	meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func set_show_xp(group_xp: Node) -> void:
	body.space.score.set_show_xp(group_xp)
	# group_xp.update_exp.connect(func(_v, _b): timer.start())
	meter.new_score(group_xp)

func update_meter(time: float, maximum: float) -> void:
	body.space.score.multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	body.space.score.multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(body.space.score.count.new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	body.space.score.multiplier.finish()
	meter.finish()
