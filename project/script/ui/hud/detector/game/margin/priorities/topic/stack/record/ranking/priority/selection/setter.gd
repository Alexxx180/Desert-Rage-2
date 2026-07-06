extends Button

@onready var margin: MarginContainer = $margin
@onready var xp: ProgressBar = margin.get_node("level/progress")
@onready var next: Label = $description/next
@onready var caption: Dictionary = {
	"selected": $description/caption/selected,
	"unselected": $description/caption/unselected
}

var priority_no: MakeStats.PRIORITIES = MakeStats.PRIORITIES.get(name)
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
	for hero in ["ray", "rock"]:
		count[hero][0].visible = !state
		count[hero][1].visible = state
	margin.visible = state
	next.visible = state

func connect_selection(ui: VBoxContainer, summary: Dictionary, deploy: HeroDeploy) -> void:
	pressed.connect(func():
		var hero: String = deploy.party.leader.name
		var prev: int = summary.hero[hero].at
		if summary.hero[hero].of[prev] == PlayerXP.MAX_LV: return
		# ui.selected = ui.addons[name]
		for priority in ui.priorities: priority.unselect()
		ui.ranking.priority.growth.heroes.get(hero).change(prev, priority_no)
		ui.selected = priority_no
		summary.hero[hero].at = priority_no
		set_hero_priority(priority_no, summary, hero)
		select()
	)

func unselect() -> void: _toggle_caption(false)
func select() -> void: _toggle_caption(true)

func set_priority_level(no: int, summary: Dictionary, hero: String) -> void:
	for levels in count[main]:
		var lv: int = summary.hero[hero].of[no]
		levels.text = str(lv)

func set_next_level(no: int, summary: Dictionary, hero: String) -> void:
	next.text = str(summary.hero[hero].of[no] + 1)
	if summary.hero[hero].of[no] == PlayerXP.MAX_LV: next.hide()

func set_hero_priority(no: int, summary: Dictionary, hero: String) -> void:
	set_priority_level(no, summary, hero)
	set_next_level(no, summary, hero)

func set_priority(no: int, summary: Dictionary) -> void:
	for hero in count: set_priority_level(no, summary, hero)
	set_next_level(no, summary, main)

func update_exp(value: int, maximum: int) -> void:
	xp.value = value
	xp.max_value = maximum
