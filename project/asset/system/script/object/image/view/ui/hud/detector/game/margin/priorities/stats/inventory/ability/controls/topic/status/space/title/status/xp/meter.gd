extends HBoxContainer

const KEY: String = "theme_override_styles/fill"

@onready var score: ProgressBar = $score
@onready var fill: StyleBoxLine = score.get(KEY)
@onready var timer: Timer = $timer

const COLOR: Dictionary = { 
	"combo": Color8(196, 150, 18, 255),
	"usual": Color8(100, 100, 175, 255) }

var fixed: bool = false

func new_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, _base_xp: int):
			if not fixed: timer.appear()
			# show()
			score.max_value = value.y
			score.value = value.x)

func update_color(color: String = "combo") -> void: # is_combo: bool, 
	fill.color = COLOR[color] # bg_
	score.set(KEY, fill)

func finish() -> void: update_color("usual")
