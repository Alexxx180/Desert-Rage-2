extends ProgressBar

@onready var cost: ProgressBar = $cost
@onready var shadow: TextureRect = $shadow
@onready var timer: Timer = $timer

const TIME: int = 1

var fixed: bool = false
var shown: bool = false
var tween: Tween

func set_fixed(state: bool) -> void:
	fixed = state
	if fixed: modulate = Color.WHITE

func use_skill(resource: Node) -> void:
	cost.max_value = resource.maximum
	cost.value = int(resource.points)
	shadow.set_value(resource)
	if not fixed: timer.appear()

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
