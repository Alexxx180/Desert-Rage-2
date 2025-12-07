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

func connect_selection(ui: VBoxContainer, summary: Dictionary, deploy: HeroDeploy) -> void:
	deploy.select_hero.connect(func(l):
		var hero: String = deploy.party.leader.name
		for priority in ui.priorities:
			if priority.priority_no == summary.hero[hero].at:
				priority.select()
			else:
				priority.unselect()
			priority.set_priority(priority.priority_no)
	)
	pressed.connect(func():
		var hero: String = deploy.party.leader.name
		if summary.hero[hero].of[summary.hero[hero].at] == PlayerXP.MAX_LV:
			return
		ui.selected = ui.addons[name]
		for priority in ui.priorities: priority.unselect()
		summary.hero[hero].at = priority_no
		select()
	)

func unselect() -> void: _toggle_caption(false)
func select() -> void: _toggle_caption(true)

func set_hero_priority(no: int, summary: Dictionary, hero: String = main) -> void:
	for caption in count[hero]:
		var lv: int = summary.hero[hero].of[no]
		caption.text = str(lv)

func set_next_level(no: int, summary: Dictionary) -> void:
	next.text = str(summary.hero[main].of[no] + 1)
	if summary.hero[main].of[no] == PlayerXP.MAX_LV: next.hide()

func set_priority(no: int, summary: Dictionary) -> void:
	for hero in count: set_hero_priority(no, summary, hero)
	set_next_level(no, summary)

func update_exp(value: int, maximum: int) -> void:
	xp.value = value
	xp.max_value = maximum
