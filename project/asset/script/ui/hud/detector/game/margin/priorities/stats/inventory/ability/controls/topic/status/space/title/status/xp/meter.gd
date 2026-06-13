extends ProgressBar

@onready var fill: StyleBoxFlat = get(KEY)
@onready var timer: Timer = $timer

var fixed: bool = false

const KEY: String = "theme_override_styles/fill"
const COLOR: Dictionary = { 
	"combo": Color8(196, 150, 18, 255),
	"usual": Color8(100, 100, 175, 255) }

func new_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(next: Vector2i, _base_xp: int):
			if not fixed: timer.appear() # show()
			max_value = next.y
			value = next.x)

func update_color(color: String = "combo") -> void: # is_combo: bool, 
	fill.color = COLOR[color] # bg_
	set(KEY, fill)

func finish() -> void: update_color("usual")
