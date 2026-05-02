extends Label

const DELAY: int = 2

@onready var timer: Timer = $timer
@onready var count: TextureRect = $count
@onready var multiplier: Label = $multiplier

#@onready var score: HBoxContainer = $score
#@onready var options: Control = $options
@onready var meter: ProgressBar = $meter

func set_fixed(state: bool) -> void:
	fixed = state
	# meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func update_meter(time: float, maximum: float) -> void:
	multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	multiplier.finish()
	meter.finish()

func set_hide_xp() -> void:
	pass

var fixed: bool = false

func set_show_xp(group_xp: Node) -> void:
	meter.new_score(group_xp)
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = base_xp + value.x
			if not fixed: timer.appear()
			# score.show()
			)

var record: int
var no: int:
	set(next):
		if not is_new_level:
			text = str(next)
		else:
			record = next
var is_new_level: bool = false
var first_entry: bool = true

func set_effect() -> void:
	create_tween().tween_method(func(w: Color):
		self_modulate = w
		if w == Color.TRANSPARENT:
			is_new_level = false
			text = str(record)
		, Color.WHITE, Color.TRANSPARENT, DELAY).set_delay(DELAY)

func new_level_up(_level: Node, _stats: Dictionary) -> void:
	if is_new_level: return # if level.summary.xp == 0: return
	if first_entry: first_entry = false ; return
	is_new_level = true
	record = int(text)
	text = tr("RECD")
	set_effect()

"""
func _ready() -> void:
	level_up.mouse_entered.connect(value.show) # next
	level_up.mouse_exited.connect(value.hide) # next
"""
