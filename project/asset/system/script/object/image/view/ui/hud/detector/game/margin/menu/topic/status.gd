extends HBoxContainer

@onready var enemy: Array[PanelContainer] = [$enemy_1] # , $enemy_2
@onready var main: HBoxContainer = $experience/xp/caption/main
@onready var level_up: TextureRect = main.get_node("space/level_up")
@onready var meter: Control = $experience/xp/meter
@onready var space: Control = meter.get_node("margin/next/space") # TODO FIX experience
@onready var score: ProgressBar = space.get_node("score")

#@onready var margin: MarginContainer = $experience/caption/main/multiplier/margin
@onready var multiplier: Control = main.get_node("multiplier")
@onready var combo: Dictionary = {
	"meter": multiplier.get_node("meter"),# space.get_node("meter"),
	"margin": multiplier.get_node("margin"),
	"score": multiplier.get_node("margin/multiplier")
}
@onready var count: Label = $experience/caption/main/space/margin/count
var fill: StyleBoxFlat = StyleBoxFlat.new()

func new_level_up(_priority: int, _level: int) -> void:
	level_up.modulate.a8 = 255
	create_tween().tween_property(level_up, "modulate", Color.TRANSPARENT, 2).set_delay(2)

# var meter: ProgressBar# scroll/margin/stack/ability/score/exp/total/combo/meter
func set_xp_score(group_xp: Node) -> void:
	var timer: Timer = $hide_xp
	timer.timeout.connect(func():
		meter.hide()
		count.hide()
		combo.margin.hide())
	group_xp.update_level.connect(new_level_up)
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = str(base_xp + value.x)
			count.show()
			meter.show()
			timer.start()
			score.max_value = value.y
			score.value = value.x)

func finish() -> void: combo.margin.hide() # for node in [space]: node.hide()

func update_meter(time: float, maximum: float) -> void:
	const MAX: float = 0.95
	var value: float = MAX - MAX * time / maximum
	combo.meter.texture.fill_to.y = value
	multiplier.visible = combo.margin.visible and value < MAX
	if multiplier.visible:
		fill.bg_color = Color8(196, 150, 18, 255)
	else:
		fill.bg_color = Color8(100, 100, 175, 255)
	score.set("theme_override_styles/fill", fill)

func update_multiplier(scored: float) -> void:
	if not meter.visible: return
	
	for node in [combo.margin, space]: node.show() # combo.meter, 
	combo.score.text = "x%.2f" % scored
