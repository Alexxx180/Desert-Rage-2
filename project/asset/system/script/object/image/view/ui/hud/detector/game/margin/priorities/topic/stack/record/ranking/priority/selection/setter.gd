extends Button

@onready var margin: MarginContainer = $margin
@onready var xp: ProgressBar = margin.get_node("level/progress")
@onready var next: Label = $description/next
@onready var caption: Dictionary = {
	"selected": $description/caption/selected,
	"unselected": $description/caption/unselected
}

@export var priority_no: MakeStats.PRIORITIES = 0

var selected: Control
var count: Dictionary = {}
var main: String = "ray"

func _ready() -> void:
	var number: HBoxContainer = $description/number
	for hero in ["ray", "rock"]:
		count[hero] = [number.get_node(hero + "/normal"),
			number.get_node(hero + "/selected")]

func _toggle_caption(state: bool) -> void:
	caption.selected.visible = state
	caption.unselected.visible = !state
	margin.visible = state
	next.visible = state

func connect_selection(ui: VBoxContainer, summary: Dictionary) -> void:
	pressed.connect(func():
		if summary.hero.ray.of[summary.hero.ray.at] == PlayerXP.MAX_LV:
			return
		ui.selected = ui.addons[name]
		for priority in ui.priorities: priority.unselect()
		summary.hero.ray.at = priority_no
		select()
	)

func unselect() -> void: _toggle_caption(false)
func select() -> void: _toggle_caption(true)

func set_priority(no: int, summary: Dictionary) -> void:
	for hero in count:
		for caption in count[hero]:
			var lv: int = summary.hero[hero].of[no]
			caption.text = str(lv)
	next.text = str(summary.hero[main].of[no] + 1)
	if summary.hero[main].of[no] == PlayerXP.MAX_LV: next.hide()

func update_exp(value: int, maximum: int) -> void:
	xp.value = value
	xp.max_value = maximum
