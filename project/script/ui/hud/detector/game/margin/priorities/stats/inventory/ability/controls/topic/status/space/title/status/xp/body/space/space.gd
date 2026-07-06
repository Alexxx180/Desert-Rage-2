extends Control

@onready var score: HBoxContainer = $score
@onready var options: Control = $options
@onready var multiplier: Control = $multiplier

@onready var meter: ProgressBar = $meter
@onready var timer: Timer = $timer

func set_fixed(state: bool) -> void:
	score.fixed = state
	# meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func set_show_xp(group_xp: Node) -> void:
	score.set_show_xp(group_xp)
	# group_xp.update_exp.connect(func(_v, _b): timer.start())
	meter.new_score(group_xp)

func update_meter(time: float, maximum: float) -> void:
	score.multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	score.multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(score.count.new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	score.multiplier.finish()
	meter.finish()

func set_hide_xp() -> void:
	pass
	#timer.timeout.connect(func():
		#pass)
		# space.score.hide()
		# space.multiplier.hide())
"""
func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			space.score.count.text = str(base_xp + value.x)
			space.score.show()
			timer.start())
"""
