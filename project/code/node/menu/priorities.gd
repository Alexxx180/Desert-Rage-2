extends HSplitContainer

@onready var stats: HSplitContainer = $stats
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation
# @onready var points: Array[Button] = _get_points()

# func _ready() -> void: drag_started.connect(topic.update_stack)

func _get_points() -> Array[Button]:
	var items: MarginContainer = stats.inventory.topic.stack.status
	var file: MarginContainer = topic.stack.status
	return [
		items.get(&"ray").get(&"health"), file.get(&"ray").get(&"health"),
		items.get(&"ray").get(&"ability"), file.get(&"ray").get(&"ability"),
		items.get(&"rock").get(&"health"), file.get(&"rock").get(&"health"),
		items.get(&"rock").get(&"ability"), file.get(&"rock").get(&"ability"),
	]


extends VBoxContainer

@onready var heroes: Array[HFlowContainer] = [$ray, $rock]
@onready var bank: VBoxContainer = $bank

func connect_opened(opened: Button, ability: VBoxContainer) -> void:
	if opened:
		opened.focus_entered.connect(func(): ability.show())
		opened.focus_exited.connect(func(): ability.hide())
		opened.mouse_entered.connect(func(): ability.show())
		opened.mouse_exited.connect(func(): ability.hide())

func connect_ability(ability: BoxContainer) -> void:
	for hero in heroes:
		var path: NodePath = NodePath(ability.name)
		if hero.has_node(path):
			connect_opened(hero.get_node(path), ability) #  + "/opened"

func connect_category(category: VBoxContainer) -> void:
	for ability in category.get_children():
		connect_ability(ability)
"""
func _ready() -> void:
	for category in bank.get_children():
		connect_category(category)
"""


extends Label

@onready var tabs: HBoxContainer = get_parent()

func transparent() -> void: tabs.modulate = Color.TRANSPARENT
func usual() -> void: tabs.modulate = Color.WHITE

func _ready() -> void:
	mouse_entered.connect(transparent)
	mouse_exited.connect(usual)



extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get:
		update_scroll()
		return _scroll

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get:
		if _stack == null: _stack = scroll.get_node("space/scroll/margin/stack")
		return _stack

func update_stack() -> void:
	if _stack == null:
		_stack = scroll.get_node("space/scroll/margin/stack")
		loaded.emit(_stack)

func update_scroll() -> void:
	if _scroll == null:
		_scroll = load(Def.priorities).instantiate()
		add_child(_scroll)



extends HBoxContainer

@onready var status: VBoxContainer = $status
@onready var synergy: ProgressBar = $synergy/points


extends VBoxContainer
"""
@onready var status: VBoxContainer = $status
@onready var card: MarginContainer = $card
@onready var record: VBoxContainer = $record
@onready var research: VBoxContainer = $research
"""



extends Control

var texts: PackedStringArray = ["Стремление", "⚖️Выдержка", "🪨Упорство"]


extends Label

var description: Array[String] = ["PR", "CM", "PE"]

func connect_priority(p: Button, record: VBoxContainer, method: String) -> void:
	# var selection: VBoxContainer = record.ranking.priority.selection
	var heroes: HBoxContainer = record.ranking.priority.growth.heroes
	var c: Array = [["nter", func(): # priority[record.selected].hide() # priority[p.priority_no].show()
		text = "P%sD" % description[p.priority_no]
		heroes.leader.stats.toggle(p.priority_no, "show")
	], ["xit", func():
		heroes.leader.stats.set_priority(p.priority_no)
		heroes.leader.priority.priorities[record.selected].show()
	]]
	for s in c: p.get("%s_e%sed" % [method, s[0]]).connect(s[1])

func connect_priorities(record: VBoxContainer) -> void:
	for p in record.priorities:
		for method in ["focus", "mouse"]:
			connect_priority(p, record, method)


extends Label

@onready var rank: Label = $rank
@onready var title: Label = $title

var status: VBoxContainer

func calculate_rank() -> void:
	pass # implement based on enemy and hero stats


extends HBoxContainer


extends Label

var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void: text = priorities[no]


extends TextureRect

@onready var priority: VBoxContainer = $back/priority
@onready var stats: VBoxContainer = $back/stats

func change(prev: int, at: int) -> void:
	priority.priorities[prev].hide()
	# priority.priorities[at].show()



@onready var rank: Label = $rank
@onready var value: Label = $value

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

var selected: String = "ray"
var leader: TextureRect:
	get: return get(selected)

func select_hero(party: HeroParty) -> void:
	selected = party.leader.name
	get(selected).show()
	get(party.follower.name).hide()



extends VBoxContainer
"""
#@onready var priority: VBoxContainer = $priority
#@onready var description: Label = $description 

@onready var growth: HBoxContainer = $growth

@onready var pursuit: Button = $pursuit
@onready var self_control: Button = $self_control
@onready var tenacity: Button = $tenacity
@onready var select: MakeStats.PRIORITIES = pursuit.priority_no

var priorities: Array[Button]:
	get: return [pursuit, self_control, tenacity]

func _toggle_call(i: Array[int], ui: VBoxContainer) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: ui.toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button, ui: VBoxContainer) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.priority_no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1], ui))

func connect_priorities(ranking: VBoxContainer) -> void:
	for ui in [ranking.priority.growth, ranking.description]:
		for priority in [pursuit, self_control, tenacity]:
			connect_priority(priority, ui)

@onready var ranking: HFlowContainer = $ranking
@onready var priorities: Array[Button] = ranking.priority.selection.priorities

var selected: int = 0

func _ready() -> void:
	ranking.description.connect_priorities(self)

func connect_priority_select(level: Node, group: Node2D) -> void:
	for button in priorities:
		button.connect_selection(self, level.summary, group.deploy)
	
	group.deploy.select_hero.connect(func(_l):
		ranking.priority.growth.heroes.select_hero(group.deploy.party)
		var hero: String = group.deploy.party.leader.name
		for priority in priorities:
			if priority.priority_no == level.summary.hero[hero].at:
				priority.select()
			else:
				priority.unselect()
			priority.set_hero_priority(priority.priority_no, level.summary, hero)
	)

func set_priorities(level: Node, _stats: Dictionary, group: Node2D) -> void:
	for i in range(0, len(priorities)):
		var hero: String = group.deploy.party.leader.name
		priorities[i].set_hero_priority(i, level.summary, hero)
	# _show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)

"""


@onready var pursuit: Button = $pursuit
@onready var self_control: Button = $self_control
@onready var tenacity: Button = $tenacity
@onready var select: MakeStats.PRIORITIES = pursuit.priority_no

var priorities: Array[Button]:
	get: return [pursuit, self_control, tenacity]

func _toggle_call(i: Array[int], ui: VBoxContainer) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: ui.toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button, ui: VBoxContainer) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.priority_no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1], ui))

func connect_priorities(ranking: VBoxContainer) -> void:
	for ui in [ranking.priority.growth, ranking.description]:
		for priority in [pursuit, self_control, tenacity]:
			connect_priority(priority, ui)



extends Button
"""
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
"""


extends Label

@onready var number: Label = $number

var addon: Array[Array] = [[0, 1], [1, 3], [2, 3]]
var icons: Array[String] = ["⚔️", "🔥", "🛡", "🫧"]
var priorities: Array[String] = ["📈", "⚖️", "🪨"]

func set_priority(no: int) -> void:
	text = priorities[no] ; hide_number()

func hides() -> void: text = '' ; hide_number()
func hide_number() -> void: number.text = ''

func toggle(no: int, _method: String) -> void:
	text = "%s\r\n%s" % [addon[no].front(), addon[no].back()]
	# number.text += (method)


extends HBoxContainer

@onready var ray: HBoxContainer = $ray



extends HSplitContainer

@onready var inventory: VSplitContainer = $inventory
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

# func _ready() -> void: drag_started.connect(topic.update_stack)



extends Button

@export var image: String = ""

@onready var equipment: ProgressBar = $equipment
@onready var base: ProgressBar = $equipment/base
@onready var number: Label = $number
@onready var icons: Label = $number/icon
@onready var BASE_MAX: int = int(base.max_value)

var equipped: bool = false
var stats_text: String
var equipments: int = 0

func _ready() -> void:
	icons.text = image
	stats_text = text

func set_base(stat: int) -> void:
	_set_base_value(stat)

func add_equip(add: int) -> void:
	var value: int = int(base.value)
	_set_equipment_value(value + add)

func _set_equipment_value(value: int) -> void:
	equipments = value
	if equipped: equipment.value = value

func _set_base_value(value: int) -> void:
	base.value = value
	number.text = str(value)
	text = stats_text
	if not equipped:
		text += " (%d)" % equipments

func _set_view_values(based: int, equip: int) -> void:
	equipment.value = equip
	base.max_value = based

func set_view_type(mode: bool) -> void:
	equipped = mode
	if equipped:
		_set_view_values(int(equipment.max_value), 0)
	else:
		_set_view_values(BASE_MAX, equipments)
	_set_base_value(int(base.value))



extends VBoxContainer

@onready var stats: Array[Button] = [$power, $influence, $vitality, $reaction]

func set_stats(values: Array) -> void:
	for i in range(0, len(stats)):
		stats[i].set_base(values[i])


extends HBoxContainer

@onready var ray: Control = $ray
@onready var rock: Control = $rock

func select_hero(party: HeroParty) -> void:
	var leader: Control = get(party.leader.name)
	var follower: Control = get(party.follower.name)
	
	leader.back.hide()
	follower.back.show()
	remove_child(follower)
	add_child(follower)




extends TextureRect#Button

signal switch_bags(bag: String)

@onready var back: PanelContainer = $back

var inventory: Node

# func _ready() -> void: pressed.connect(switch)

func set_inventory(group: Node2D) -> void:
	inventory = group.get(name).to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: trade(cell)

func trade(cell: Control) -> void:
	var slot: int = inventory.logic.find_empty_slot()
	if slot != inventory.logic.items.ui.NONE:
		cell.image.holder = null
		cell.inventory.logic.trade_bags(inventory.logic, cell.slot, slot)

func switch() -> void: switch_bags.emit(name)



extends Label

var stats: Dictionary = {
	"power": "SPWD", "influence": "SNFD",
	"vitality": "SVTD", "reaction": "SRCD"
}

func sets(stat: String) -> void:
	text = tr(stats[stat])


extends MarginContainer

@onready var bag: HBoxContainer = $value/bag
@onready var description: Label = $description
@onready var heroes: Array = [$value/heroes/ray, $value/heroes/rock] #@onready var heroes: HBoxContainer = $heroes
var main: VBoxContainer:
	get: return heroes[0] # @onready var description: VBoxContainer = $description

func set_stats(summary: Dictionary, hero: String) -> void:
	main.set_stats(summary.stats[hero]) # var summary: Dictionary = level.summary

func connect_description(opened: Button) -> void:
	opened.focus_entered.connect(func(): description.sets(opened.name)) # opened.focus_exited.connect(func(): caption.hide())
	opened.mouse_entered.connect(func(): description.sets(opened.name)) # opened.mouse_exited.connect(func(): caption.hide())

#func _ready() -> void:
#	for caption in main.stats: connect_description(caption) # for caption in description.get_children():



extends HBoxContainer

@onready var equip: Button = $equip
@onready var state: Control = $state



extends VBoxContainer

"""
var chat: VBoxContainer

@onready var logs: PanelContainer = $log
@onready var items: PanelContainer = $notes
@onready var notes: PanelContainer = $notes
@onready var title: VBoxContainer = $title
@onready var card: MarginContainer = $card
"""




extends VBoxContainer

@onready var bag: HFlowContainer = $bag
@onready var stats: VBoxContainer = $stats
@onready var chats: VBoxContainer = $chats

func connect_bag(ui: Array, inventory: HFlowContainer, opened: Node) -> void:
	for change in ui:
		for b in [bag, inventory]:
			change.switch_bags.connect(b.switch)
		change.switch_bags.connect(func(h):
			opened.bag = h
			opened.other = !opened.other)

func toggle_buttons(stack: VBoxContainer, status: VBoxContainer, leader: String, opened: Node, feedback: Callable) -> Array:
	var b: Button = stack.status.get(leader).bag
	var b2: Button = status.get(leader).bag
	var ui: TextureButton = stats.stats.bag.get(leader)
	var res: Array = [ui, b, b2]
	for i in res: feedback.call(i)
	return res

func _toggle_order(stack: VBoxContainer, status: VBoxContainer, party: HeroParty, opened: Node) -> void:
	for i in [[party.leader.name, func(i): i.disabled = true], [party.follower.name, func(i): i.disabled = false]]:
		toggle_buttons(stack, status, i[0], opened, i[1])

func connect_group(stack: VBoxContainer, status: VBoxContainer, group: Node2D, opened: Node) -> void:
	stack.connect_group(group)
	for hero in ["ray", "rock"]:
		for bg in [bag, stack.bag]: bg.connect_group(hero, group, opened)
		var res = toggle_buttons(stack, status, hero, opened, func(i): i.set_inventory(group))
		connect_bag(res, stack.bag, opened)
	group.deploy.select_hero.connect(func(_h):
		bag.select_hero(group)
		stack.bag.select_hero(group)
		opened.bag = group.deploy.party.follower.name
		
		_toggle_order(stack, status, group.deploy.party, opened)
	)
	_toggle_order(stack, status, group.deploy.party, opened)



extends PanelContainer

signal loaded(stack: Container)

var _scroll: ScrollContainer = null
var scroll: ScrollContainer:
	get: return update_scroll()

var _stack: VBoxContainer = null
var stack: VBoxContainer:
	get: return update_stack()

func update_stack() -> VBoxContainer:
	if _stack == null:
		_stack = scroll.get_node("control/scroll/margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null # Works.upload(self, _scroll, Def.game % "stats", "stats")
