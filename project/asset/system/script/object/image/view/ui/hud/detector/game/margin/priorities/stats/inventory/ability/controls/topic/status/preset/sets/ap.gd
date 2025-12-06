extends ProgressBar

@onready var cost: ProgressBar = $cost
@onready var shadow: TextureRect = $shadow

const TIME: int = 1

var shown: bool = false
var tween: Tween

func show_cost(points: int, delta: int) -> void:
	value = points
	cost.value = points - delta
	shown = true
	animate_cost()

func hide_cost() -> void:
	shown = false
	value = 0

func animate_cost() -> void:
	if not shown: return
	var next: Color = Color.WHITE
	if self_modulate == Color.WHITE:
		next = Color.BLACK
	tween = create_tween()
	tween.tween_property(self, "self_modulate", next, TIME)
	tween.tween_callback(animate_cost)
