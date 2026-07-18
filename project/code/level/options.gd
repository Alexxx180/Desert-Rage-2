extends HBoxContainer

@onready var pause: Button = $pause
@onready var menu: Button = $menu
@onready var icons: Button = $icons


extends Button

@onready var margin: MarginContainer = $margin



extends MarginContainer

@onready var icon: TextureRect = $icon



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



extends Control

@onready var timer: Timer = $timer
@onready var count: TextureRect = $count
@onready var multiplier: Label = $multiplier

var fixed: bool = false

func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = base_xp + value.x
			if not fixed: timer.appear()
			# score.show()
			)




extends Label

@onready var modulator: Node = $modulator

func finish() -> void: modulator.disappear(self)

func multiply(x: String) -> String:
	return x.substr(0, x.rfind("0")) + "x" if x[-2] == "0" else x

func update_x(score: float) -> void:
	show()
	text = multiply("%.2fx" % score)

func update_meter(time: float, maximum: float) -> void:
	var portion: float = time / maximum
	material.set("shader_parameter/dissolve_value", portion)
	modulator.appear(self)



extends Control

@onready var score: HBoxContainer = $score
@onready var options: Control = $options
@onready var multiplier: Control = $multiplier

@onready var meter: ProgressBar = $meter
@onready var timer: Timer = $timer

func set_fixed(state: bool) -> void:
	score.fixed = state
	# meter.fixed = state
#	if not fixed:
		#pass
		#body.set_hide_xp()
		# body.timer.timeout.connect(meter.hide)

func set_show_xp(group_xp: Node) -> void:
	score.set_show_xp(group_xp)
	# group_xp.update_exp.connect(func(_v, _b): timer.start())
	meter.new_score(group_xp)

func update_meter(time: float, maximum: float) -> void:
	score.multiplier.update_meter(time, maximum)
	meter.update_color()#body.space.multiplier.is_combo)

func update_multiplier(scored: float) -> void:
	score.multiplier.update_x(scored)

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_priorities.connect(score.count.new_level_up)
	# set_hide_xp()
	set_show_xp(group_xp)

func finish() -> void:
	score.multiplier.finish()
	meter.finish()

func set_hide_xp() -> void:
	pass
	#timer.timeout.connect(func():
		#pass)
		# space.score.hide()
		# space.multiplier.hide())
"""
func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			space.score.count.text = str(base_xp + value.x)
			space.score.show()
			timer.start())
"""




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



extends HBoxContainer

@onready var slot: Label = $slot
@onready var time: PanelContainer = $time

var _hits: HBoxContainer = null
var hits: HBoxContainer:
	get:
		return null #  Works.upload(self, _hits, LoadBus.hits, "hits")

var _xp: Label = null
var xp: Label:
	get: return null # Works.upload(self, _xp, LoadBus.xp, "xp")

func update_meter(duration: float, mx: float) -> void: xp.update_meter(duration, mx)

func update_multiplier(score: float) -> void: xp.update_multiplier(score)

func set_xp_score(group_xp: Node) -> void: xp.set_xp_score(group_xp)

func finish() -> void: xp.finish()




extends Label

@onready var number: ProgressBar = $number
@onready var lasted: ProgressBar = $timing/lasted

const NUMBER: int = 60

func tick(value: int) -> void:
	if value < NUMBER:
		number.text = str(value)
	else:
		number.text = "%d:%02d" % [value / NUMBER, value % NUMBER]
	lasted.value = value




extends HBoxContainer

@onready var status: HBoxContainer = $enemies/margin/status
@onready var enemies: Control = $enemies




extends Control

@onready var title: HBoxContainer = $title
@onready var slots: ColorRect = $slots



extends HBoxContainer

@export var fixed: bool = false

@onready var space: Control = $space
@onready var preset: HBoxContainer = $preset

func _ready() -> void:
	space.title.status.xp.set_fixed(fixed)
	# preset.sets.ap.set_fixed(fixed) #TODO FIXME SET FIXED




extends PanelContainer

@onready var status: Label = $margin/description
@onready var timing: Timer = $hiding
@onready var health: ProgressBar = $health
@onready var aura: ProgressBar = $aura
@onready var slot: Label = $slot

func _ready() -> void:
	timing.timeout.connect(hide)

func reload_timer():
	if not status.visible:
		show()
	timing.start()
	return self

func notify(text: String) -> void:
	status.text = text
	reload_timer().show()

func new_slot(unicode: String) -> void:
	slot.text = unicode
	slot.modulate = Color.WHITE
	create_tween().tween_property(slot, "modulate", Color.TRANSPARENT, 2.0)

func hp_change(next: int) -> void:
	reload_timer().health.value = next

func ap_change(next: int) -> void:
	reload_timer().aura.value = next




extends VSplitContainer

@onready var controls: VBoxContainer = $margin/controls
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

#func _ready() -> void: drag_started.connect(topic.update_stack)


extends VBoxContainer

@onready var next_score: Label = $experience/next_score/count

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			next_score.text = str(value.y - value.x))

#func finish() -> void: pass
#func update_meter() -> void: 


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
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null #  Works.upload(self, _scroll, Def.ability, "ability")


extends VBoxContainer

@onready var space: Control = $space
@onready var perks: VBoxContainer = $perks
@onready var item: VBoxContainer = $item

func select_hero(party: HeroParty) -> void:
	space.status.preset.sets.skill.select_hero(party)
	item.select_hero(party)


extends HBoxContainer

@onready var title: VBoxContainer = $title
@onready var sets: VBoxContainer = $sets


extends VBoxContainer

@onready var ray: HBoxContainer = $ray
@onready var rock: HBoxContainer = $rock

func select_hero(party: HeroParty) -> void:
	get(party.follower.name).hide()
	get(party.leader.name).show()


extends Control

@onready var status: HBoxContainer = $status
@onready var slots: ColorRect = $description



extends Control

@onready var topic: Control = $topic
@onready var status: HBoxContainer = $status

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get: return Works.upload_at(status, _hp, "hp", Def.mhealth, "hp")

var markers: HFlowContainer:
	get: return null# Works.uploads(self, Def.items, "markers") # TODO SET  MARKERS FREE FROM LINKING

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return null# Works.upload_at(self, status, _hints, Def.hints % "hints", "hints")

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		




extends ProgressBar

@onready var health: ProgressBar = $health
@onready var contested: ProgressBar = self
@onready var caption: PanelContainer = $text # TODO fix caption and interrogate for enemy
@onready var modulator: Node = $modulator
@onready var damage: Label = caption.get_node("damage")
@onready var hits: HBoxContainer = get_node("../margin/status/hits") #$content/hits
@onready var back: TextureRect = damage.get_node("back") # @onready var interrogate: Label = $margin/contents/interrogate
@onready var damages: HBoxContainer = damage.get_node("margin/damage")

@onready var health_back: StyleBoxFlat = health.get("theme_override_styles/background")

func _ready() -> void: caption.health = health
func appear() -> void: modulator.appear(self)
func disappear() -> void: modulator.disappear(self)

func animate() -> void:
	health_back.content_margin_bottom = 0 # TODO TWEEN VALUE HERE
	damage.text = "ONA! - BAM!"

func set_hp(hp: Node) -> void:
	damages.health.text = str(int(hp.contested))
	damages.value.text = str(int(hp.contested - hp.points))
	back.set_value(hp)



extends HBoxContainer

@export var fixed: bool = false
@onready var status: HBoxContainer = $status
@onready var preset: HBoxContainer = $preset
@onready var skills: PanelContainer = get_node("../../hints/space/scroll/stack/skills")

# func _update_pause() -> Variant: return Works.upload_hold(self, "holder", _pause, LoadBus.pause, "pause")

var _pause: HBoxContainer = null
var pause: HBoxContainer:
	get: return null # _update_pause()

Def.enemy
var _enemy: PanelContainer = null
var enemy: PanelContainer:
	get: return null # Works.upload_hold(self, "space", _enemy, Def.enemy, "enemy")

var _slots: ColorRect = null
var slots: ColorRect:
	get: return null # Works.upload_at(self, status, _slots, LoadBus.slots, "slots")

#func _ready() -> void:
#	$holder.mouse_entered.connect(_update_pause) #status.xp.set_fixed(fixed)



extends Label

func change(hp: Node) -> void: # text = str(int(hp.contested))
	var delta: int = hp.contested - hp.points # int(
	var op: String = "^" ; if delta < 0: op = ">"
	text = "%d %s %d" % [hp.contested, op, abs(delta)] # int()


extends TextureRect

const MAX: float = 0.95

func set_value(points: Node) -> void:
	var value: float = MAX - MAX * points.points / points.maximum
	texture.fill_from.y = value
	# visible = value < MAX



extends Label

@onready var lamp: Control = $lamp
@onready var back: TextureRect = $back
@onready var margin: MarginContainer = $margin
@onready var timer: Timer = $timer
@onready var hiding: Timer = $hiding

var combos: Node
var health: ProgressBar
var interrogating: bool = false
var _title: String

func set_title(title: String) -> void:
	_title = title
	enemy.text = title

func _ready() -> void:
	timer.timeout.connect(set_disabled_tint)

func set_tint(a: int) -> void:
	lamp.modulate = Color8(255, 255, 255, a) # back.modulate = Color8(255, 255, 255, a)
	margin.modulate = Color8(255, 255, 255, a)

func set_disabled_tint() -> void:
	if not interrogating:
		set_tint(255)
		back.visible = true
		# if combo.fixate_card(health.value, _title): return
		hiding.start()

func show_start() -> void:
	# combo.has_card TODO FIXME add to condition with and
	if timer.is_stopped() and hiding.is_stopped():
		timer.start()
		set_tint(60)
		back.visible = false




extends MarginContainer

@onready var caption: PanelContainer = $title/caption
@onready var animation: Control = $title/animation

func appear(tween: Tween) -> void:
	pass

func disappear(tween: Tween) -> void:
	tween.
	animation
	pass


extends HBoxContainer

enum { DIGIT = 10, MAX = 999 }

@onready var digits: Array[Control] = [$hundred, $ten, $one]

func hide_all() -> void:
	hide()
	for digit in digits: digit.hide_digit()

func set_count(hits: int) -> void:
	if hits > MAX: return
	show() # var x: Array[int] = [100, 10, 1]
	for i in range(0, 3):
		digits[i].set_digit(hits / (DIGIT ** (2 - i)) % DIGIT)


extends Node

@onready var count: Label = $count


extends Control

@onready var margin: Array = [$a, $b, $c]
@onready var timer: Timer = $timer

const MARGIN: int = 25
const TIME: float = 0.6

var delayed: bool = false
var digit: int = 0
var cycle: int = 0

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

func hide_digit() -> void:
	digit = 0
	for m in margin: m.count.text = ''
	delayed = false

func set_disabled_tint() -> void: for i in len(margin): set_hide(i)

func _modulate(tween: Tween, m, color) -> void:
	tween.tween_property(m, "modulate", color, TIME)

func set_hide(n: int) -> void:
	var tween: Tween = create_tween()
	_modulate(tween, margin[n], Color.TRANSPARENT)

func animate(no: int) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(func(v): set_margin(margin[no], v), MARGIN, -MARGIN, TIME)
	timer.start()

func set_margin(m: MarginContainer, v) -> void:
	m.modulate = Color8(255, 255, 255, 255 / MARGIN * (MARGIN - abs(v)))
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)
	if v == 8: delayed = false #cycle = min(cycle + 1, 1) #-20
	# if v <= -25 and delayed: delayed = false

func set_hit_value() -> void:
	margin[cycle].add_theme_constant_override("margin_top", -MARGIN)
	margin[cycle].add_theme_constant_override("margin_bottom", MARGIN)
	margin[cycle].count.text = str(digit)

func set_digit(next: int) -> void:
	if next != digit and not delayed: # and cycle > Defaults.INT
		delayed = true
		digit = next
		margin[cycle].modulate = Color.TRANSPARENT
		set_hit_value() # m
		animate(cycle)
		cycle = (cycle + 1) % len(margin)



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


extends MarginContainer

@onready var sets: HBoxContainer = $options/sets
@onready var analyze: Button = $options/analyze

func select_hero(party: HeroParty) -> void:
	sets.get(party.leader.name).show()
	sets.get(party.follower.name).hide()


extends HBoxContainer

@onready var ray: HBoxContainer = $ray
@onready var rock: HBoxContainer = $rock



extends VBoxContainer

@onready var ap: ProgressBar = $ap/current
@onready var skill: MarginContainer = $skill

func use_skill(resource: Node) -> void:
	ap.use_skill(resource)
	#ap.cost.max_value = resource.maximum
	#ap.cost.value = int(resource.points)



extends HBoxContainer

@onready var sets: VBoxContainer = $skill/sets




extends VSplitContainer

@onready var ability: VSplitContainer = $ability
@onready var topic: PanelContainer = $topic
@onready var navigation: Node = $navigation

# func _ready() -> void: drag_started.connect(topic.update_stack)


extends Label

var tools: Dictionary

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_delay(1)
	tween.tween_callback(disappear)

func disappear() -> void:
	tools.combos = null
	queue_free()



extends Button

signal switch_bags(bag: String)

var inventory: Node
var hero: String

func set_inventory(group: Node2D) -> void:
	inventory = group.get(hero).to.inventory

func _ready() -> void:
	pressed.connect(switch)
	if text == "Рок": $icon.hide()

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: trade(cell)

func trade(cell: Control) -> void:
	var slot: int = inventory.logic.find_empty_slot()
	if slot != inventory.logic.items.ui.NONE:
		cell.image.holder = null
		cell.inventory.logic.trade_bags(inventory.logic, cell.slot, slot)

func switch() -> void: switch_bags.emit(hero)



class_name StatusPoints extends Button

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

var cells: Array[int] = []
var inventory: Node

func key() -> String: return "h"

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)

func set_inventory(hero: CharacterBody2D) -> void:
	inventory = hero.to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag and inventory.logic.sorting.fillable(cell, key())
	
func _drop_data(_pos: Vector2, cell: Variant) -> void:
	if cell.drag.ui.logic.sorting.use_as_slot(cell.slot) == 0:
		cell.drag.ui.reset_holder()



extends StatusPoints

func set_inventory(hero: CharacterBody2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.quick_heal)



extends StatusPoints

func key() -> String: return "a"

func set_inventory(hero: Node2D) -> void:
	super.set_inventory(hero)
	pressed.connect(inventory.logic.sorting.reload_resource)




extends VBoxContainer

@onready var space: Control = $space
@onready var status: Control = $status

const PIN: Vector2i = Vector2i(0, 15)
const DURATION: int = 2

func toggle(pos: Vector2, clr: Color, feedback: Callable) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(space, "custom_minimum_size", pos, DURATION)
	tween.tween_property(space, "modulate", clr, DURATION)
	tween.tween_callback(feedback)

func shows() -> void:
	space.custom_minimum_size = PIN
	toggle(Vector2.ZERO, Color.WHITE, show)

func hides() -> void:
	toggle(PIN, Color.TRANSPARENT, hide)



extends PanelContainer

@export var ailment: Control = self

func hide_out() -> void:
	ailment.hide()




extends Container

@onready var ray: HFlowContainer = $ray
@onready var rock: HFlowContainer = $rock

func select_hero(group: Node2D) -> void:
	get(group.deploy.party.leader.name).bag.hide()
	var follower: String = group.deploy.party.follower.name
	var ui: HFlowContainer = get(follower)
	ui.bag.show()
	remove_child(ui)
	add_child(ui)



extends HBoxContainer
"""
@export var is_bag: bool = false

@onready var health: Button = $health
@onready var ability: Button = $ability
var bag: Button

func _ready() -> void: 
	if is_bag:
		bag = preload("res://asset/scene/ui/hud/detector/game/menu/inventory/status/shared/bag.tscn").instantiate()
		bag.hero = name
		add_child(bag)
"""



extends MarginContainer

@onready var items: HFlowContainer = $items

# func _ready() -> void: items.set_items(name)




extends HFlowContainer

var _ray: HFlowContainer = null
var ray: HFlowContainer:
	get: upload_bag(_ray, "ray") ; return _ray

var _rock: HFlowContainer = null
var rock: HFlowContainer:
	get: upload_bag(_rock, "rock") ; return _rock

func upload_bag(hero: HFlowContainer, title: String) -> void:
	if hero == null:
		hero = PreloadBus.bag.instantiate() # set("_" + title, hero) if ref won't work
		hero.name = title
		var space: Control = get_node(title)
		space.add_sibling(hero)
		remove_child(space)

var opened: Node

func hides() -> void: get(opened.bag).hide()
func shows() -> void: get(opened.bag).show()

func connect_group(hero: String, group: Node2D, _opened: Node) -> void:
	var ui: HFlowContainer = get(hero).items
	group.get(hero).to.inventory.logic.trade.ui.set_items(ui)
	opened = _opened

func select_hero(group: Node) -> void:
	var leader: String = group.deploy.party.leader.name
	var follower: String = group.deploy.party.follower.name
	get(leader).show()
	var ui: MarginContainer = get(follower)
	ui.visible = opened.other
	remove_child(ui)
	add_child(ui)

func switch(hero: String) -> void:
	if opened.bag == hero:
		get(hero).visible = !get(hero).visible
	else:
		get(opened.bag).hide()
		get(hero).show()



extends VBoxContainer

@onready var bag: HFlowContainer = $bag# $items/bag
@onready var status: HFlowContainer = $status
@onready var sticker: MarginContainer = $sticker

func connect_group(group: Node2D) -> void:
	group.deploy.select_hero.connect(func(_h): status.select_hero(group))





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
		_stack = scroll.get_node("margin/stack")
		loaded.emit(_stack)
	return _stack

func update_scroll() -> ScrollContainer:
	return null #Works.upload(self, _scroll, LoadBus.inventory, "scroll")




extends Button

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

var trade: Node

func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: trade.trades(cell)

@onready var component: HBoxContainer = $component
@onready var title: HBoxContainer = $short/title
@onready var caption: Label = $short/margin/caption
@onready var effect: Label = $effect

func set_item(item: Dictionary) -> void:
	component.describe(item)
	title.set_item(item) #effects.set_effect(item.logic)
	effect.text = item.item.description
	caption.text = item.item.name

func helping() -> void:
	component.hides()
	title.effects.hide()
	caption.text = "Инвентарь, ЛКМ"
	title.effect.text = "Область для осмотра"

func equipment(slots: Array, equip: Dictionary) -> void:
	component.equipment(slots, equip.logic)
	# set_item(equip)

func production(slots: Array) -> void:
	component.production(slots)
	if slots.is_empty():
		helping()
	else:
		set_item(slots.back().item)



extends HBoxContainer

@onready var effect: Label = $effect
@onready var effects: HBoxContainer = $effects

func set_item(item: Dictionary) -> void:
	effect.text = item.item.short
	effects.set_effect(item.logic)


extends HBoxContainer

@onready var aura: PanelContainer = $aura
@onready var resource: PanelContainer = $resource
@onready var no_enemy: PanelContainer = $no_enemy
@onready var no_poison: PanelContainer = $no_poison
@onready var no_cough: PanelContainer = $no_cough

func hides() -> void: for i in get_children(): i.hide()

func saura() -> String:
	aura.show()
	return "aura shown"

func sresource() -> String:
	resource.show()
	return "resource shown"

func set_refill(item: IUse) -> void:
	hides()
	item.imagine(self)

func set_effect(item: Variant) -> void:
	hides()
	var sticker = get(item.effect)
	if sticker:
		sticker.show()



extends HBoxContainer

@onready var status: HBoxContainer = $status
@onready var timing: VBoxContainer = $timing

func set_values(item: IUse) -> void:
	timing.set_power(item)
	status.set_refill(item)

func set_status(item: Variant) -> void:
	status.set_effect(item)
	#if 
	#timing.set_time(item.time)

func set_effect(item: Variant) -> void:
	show()
	if item is IUse:
		set_values(item)
	else:
		set_status(item)



extends VBoxContainer

@onready var effect: Label = $effect
@onready var time: ProgressBar = $time

const PERIOD: float = 60

func a() -> String: return "A"
func r() -> String: return "R"
func ar() -> String: return a() + r()
func both() -> String: return "%d " + ar() + " %d"

func set_time(seconds: int) -> void:
	show()
	if seconds < PERIOD:
		effect.text = "%d s." % seconds
	else:
		effect.text = "%.1f m. " % (seconds / PERIOD)

func set_power(item: IUse) -> void:
	show()
	effect.text = item.describe(self)




extends HFlowContainer

@onready var slots: Array[Node] = get_children()

var _title: HBoxContainer
var title: HBoxContainer:
	get: return Def.lazy(self, _title, Def.title, &"title")

# func _ready() -> void:
	# for i in range(0, HeroInventory.SLOTS): slots[i].slot = i


extends Button

@onready var stand: VBoxContainer = $content
@onready var collapsed: Control = stand.get_node("collapsed")
@onready var selected: Control = stand.get_node("selected")
@onready var preview: Control = stand.get_node("selected/image")

func toggle(selection: bool) -> void:
	collapsed.visible = !selection
	selected.visible = selection

func hide_item() -> void:
	toggle(false)
	preview.hide()

func _ready() -> void:
	mouse_entered.connect(func(): stand.show())
	mouse_exited.connect(func(): stand.hide())

func show_item() -> void:
	toggle(true)
	preview.show()


class_name InventoryItem extends Button

@onready var margin: MarginContainer = $margin

func _ready() -> void: pressed.connect(select_item)

func select_item() -> void:
	margin.view.drag.craft.selection.select_item(margin.view)

func remove_item() -> void: margin.remove_item()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	margin.replace_item(next, prev)

func put_item(slot: Dictionary) -> void: margin.put_item(slot)


extends InventoryItem

# func _get_drag_data(_p) -> InventoryItem: return set_preview(self)
# func _can_drop_data(_p, cell: Variant) -> bool: return cell is InventoryItem
# func _drop_data(_p, cell: Variant) -> void: trades(cell, self)

@onready var color: ColorRect = $margin/selection/fast/color
@onready var back: TextureRect = $margin/selection/fast/back

func _toggle(state: bool) -> void: # progress color: #999999
	color.visible = state
	back.visible = state

func show_selection() -> void: _toggle(true)
func hide_selection() -> void: _toggle(false)

@onready var bar: ProgressBar = $bar
@onready var number: Label = $number

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	show()
	if next == BOUNDARY:
		remove_item()
	else:
		set_values(str(next), next)

func set_values(label: String, next: int) -> void:
	number.text = label
	bar.value = next

func remove_item() -> void: set_values("", 0)



extends InventoryItem

@onready var default: Control = $default

func remove_item() -> void:
	super.remove_item()
	default.show()

func put_item(selected: Dictionary) -> void:
	default.hide()
	super.put_item(selected)





extends Button

@onready var view: TextureRect = $view

func _ready() -> void: pressed.connect(select_item)

func put_item(item: Dictionary) -> void:
	show()
	view.drag.ui.put_item(item, view.image)

func select_item() -> void:
	view.drag.select_item(self)


extends MarginContainer

@onready var view: Control = $view




class_name CellDrag extends TextureRect

@onready var count: Label = $count
@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

const BOUNDARY: int = 1

var slot: int
var drag: Node

func _get_drag_data(_p) -> CellDrag: return drag.ui.set_preview(self)
func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: drag.trades(cell, self)

func remove_item() -> void: # var inventory: Node # TODOT inv
	drag.ui.remove_item(image)
	count.text = ""

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	for item in [next, prev]: put_item(item)

func put_item(item: Dictionary) -> void:
	drag.ui.put_item(item, image)
	set_value(item.x)

func set_value(next: int) -> void:
	count.text = "" if next == BOUNDARY else str(next)



extends Control

@onready var fast: VBoxContainer = $fast
@onready var count: VBoxContainer = $count

func put_item(slot: Dictionary) -> void:
	count.set_value(slot.x)

func remove_item() -> void:
	count.remove_item()


extends VBoxContainer

@onready var color: ColorRect = $color
@onready var back: TextureRect = $back


extends Label

const BOUNDARY: int = 1

func set_value(next: int) -> void:
	text = "" if next == BOUNDARY else str(next)




extends HBoxContainer

#@onready var status: MarginContainer = $ap/margin/combo/status
#@onready var status_caption: Label = status.get_node("caption")
@onready var health: Label = $health/status/margin/hp/health
@onready var damage: Label = $health/status/margin/hp/damage

@onready var status: MarginContainer = $health/status/margin
@onready var back: TextureRect = $health/status/back
@onready var timer: Timer = $timer

const MAX: float = 0.95
#@onready var slots: HBoxContainer = $ap/margin/combo/slots

func _ready() -> void:
	timer.timeout.connect(hide_status)

func hide_status() -> void:
	status.hide()
	back.hide()

func set_hp(hp: Node) -> void:
	status.show()
	
	health.text = str(int(hp.contested))
	damage.text = "-" + str(int(hp.contested - hp.points))
	var value: float = MAX * hp.points / hp.maximum
	back.texture.fill_to.y = value
	back.visible = value > 0
	
	timer.start()


extends MarginContainer

@onready var stack: HFlowContainer = $score/stack



extends Node

@onready var slots: Array = [
	$slot_1, $slot_2, $slot_3, $slot_4
]

# TODO slots

extends HBoxContainer

@onready var slot: Label = $slot

var text: String:
	set(value): slot.text = value




extends Node

@onready var margin: MarginContainer = $margin

var items: Array
var control: bool = true

func _ready() -> void:
	for i in range(1, 11):
		items.append(get_node("item_" + str(i % 10)))



extends HBoxContainer

@onready var slot: Button = $slot
@onready var workspace: PanelContainer = $workspace

func _ready() -> void:
	return
	helping()
	workspace.cancel.pressed.connect(select_space)

func select_space() -> void:
	slot.margin.view.drag.select_space()

func equipment(slots: Array, item: Dictionary) -> void:
	workspace.stack.equipment(slots, item)

func production(slots: Array) -> void:
	workspace.stack.production(slots)
	if slot.visible and slots.is_empty():
		slot.hide()

func describe(item: Dictionary) -> void:
	workspace.stack.set_item(item)

func put_product(item: Dictionary) -> void: slot.put_item(item)

func helping() -> void:
	slot.hide()
	workspace.stack.helping()




extends TextureRect

@onready var image: TextureRect = $image

func put_item(icon: String) -> void:
	var path: String = ICONS + icon
	texture = ImageTexture.create_from_image(Image.load_from_file(path))

func hides() -> void:
	image.remove_item()
	hide()

@onready var a: PanelContainer = $a
@onready var b: PanelContainer = $b

# func hides() -> void: for i in [a, b]: i.hides()
func shows() -> void: for i in [a, b]: i.show()

const ICONS: String = "res://asset/resource/media/image/inventory/"

func remove_item() -> void: texture = null


extends GridContainer

@onready var items: Array[Control] = [$a, $b]

func hides() -> void: for i in items: i.hides()

func _iterate(rang: Variant, feedback: Callable) -> void:
	for i in rang:
		feedback.call(i)
		items[i].show()

func equipment(slots: Array, item: IArmor) -> void: #production(slots) # item.equip.size()
	#items[0].put_item(slots[0].item.item.icon)
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func production(slots: Array) -> void:
	hides()
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func describe(item: Dictionary) -> void:
	hides()
	if item.logic is IArmor:
		_iterate(len(item.logic.equip), func(_i): pass)




extends GridContainer

var hero_name: String = "ray"

@onready var skills: Dictionary = {
	"ray": {
		"head": $margin/ray,
		"slap": $margin/ray/left/weapon/knuckles/slap
	},
	"rock": {
		"head": $margin/rock,
		"slap": $margin/rock/left/weapon/knuckles/slap
	},
}

func init_focus() -> void:
	skills[hero_name].slap.grab_focus()

func select_hero(hero: CharacterBody2D) -> void:
	skills[hero_name].head.hide()
	hero_name = hero.name
	skills[hero_name].head.show()




extends VBoxContainer

@onready var first: Control = $first

func append(next: Label) -> void:
	add_child(next)

func insert(next: Label) -> void:
	next.visible_characters = -1
	first.add_sibling(next)


extends VBoxContainer

@onready var timer: Timer = $timer
@onready var chat: Array[Label] = [
	$queued/margin/label, $answer/margin/label
]
@onready var panel: Array[PanelContainer] = [$queued, $answer]

var capacity: int = 0
var messages: Array[String]

func restart() -> void:
	var length: float = messages[0].length()
	timer.stop()
	timer.wait_time = 2.0 + length / 48.0
	timer.start()
	"""
	print("capacity: ", 0)
	print("message: ", messages[0])
	print("wait: ", timer.wait_time)
	"""

func sync_messages() -> void:
	var length: int = 2
	var count: int = min(capacity, length)
	for i in range(1, count + 1):
		panel[length - i].show()
		chat[length - i].text = messages[count - i]

func add_blocks(plot: Array[String]) -> void:
	for block in plot: add_block(block)
	print("messages: ", messages)
	print("capacity: ", capacity)

func add_block(text: String) -> void:
	messages.push_back(text)
	capacity += 1
	#panel[2 - capacity].show()
	if capacity == 1:
		sync_messages()
		restart()

func free_capacity() -> void:
	messages.pop_front()
	capacity -= 1
	if capacity < 2:
		panel[1 - capacity].hide()
	if capacity == 0:
		timer.stop()
	else:
		sync_messages()
		restart()


extends PanelContainer

@onready var 


extends Label

const DURATION: float = 0.5

var title: Label

func say(who: String, key: String) -> void:
	title = $title
	title.text = who
	text = key
	create_tween().tween_property(title, "modulate", Color.TRANSPARENT, DURATION).set_delay(1)





extends VBoxContainer

@onready var scroll: ScrollContainer

func _ready() -> void:
	var s = get_node("../..")
	if s is ScrollContainer:
		scroll = s

func add_childs(stack: VBoxContainer, scene: PackedScene, feedback: Callable) -> PanelContainer:
	var node: PanelContainer = scene.instantiate()
	stack.add_child(node)
	feedback.call(node)
	return node

func add_log(scene: PackedScene, feedback: Callable) -> void:
	var lg: PanelContainer = add_childs(scroll.list.logs.chat, scene, feedback)
	var tween = create_tween()
	tween.tween_property(lg, "modulate", Color.TRANSPARENT, 0.5).set_delay(3)
	tween.tween_callback(func():
		scroll.list.logs.chat.remove_child(lg) # scroll.log
		lg.queue_free())
	add_childs(self, scene, feedback)
	scroll.down()

func set_priority(level: Node, stats: Dictionary) -> void:
	if level.summary != level.prev:
		add_log(PreloadBus.levels, func(node): node.set_priority(level, stats))

func add_item(thing: String) -> void: add_log(PreloadBus.item, func(n): n.chest(thing))
func add_enemy(thing: String) -> void: add_log(PreloadBus.item, func(n): n.analyze(thing))
func add_any(thing: String) -> void: add_log(PreloadBus.item, func(n): n.say(thing))




extends PanelContainer

@onready var hero: VBoxContainer = $hero

func say(who: String, what: String) -> void:
	hero.say(who, what)




extends Label

var items: Array[String] = [
	"А что нашлось то тут у нас... %s", "%s? Отдавай сундук!",
	"%s, по сусекам наскреб", "%s с нами", "Тук-тук, кто там? %s",
	"Давно не виделись, %s", "Прошу на борт, %s", "Глянем... %s",
	"Вот это %s, я понимаю", "%s моей мечты",
	"%s... а подтираться этим можно?"]

func say(message: String, params: Array = []) -> void:
	text = message % params

func chest(item: String) -> void:
	print("ADD ITEM = ", item)
	say(items.pick_random(), [item])

func analyze(enemy: String) -> void:
	say("Сведения о %s добавлены в базу данных", [enemy])



extends Control

enum { MAX = 45, OFFSET = 30, DEGREE = 60 }

@export_range(3, 20, 1) var sides: int = 6

@onready var centered: Rect2 = Rect2(custom_minimum_size / 2, custom_minimum_size)

var colors: Dictionary = {
	"line": clr(28, 53), "polygon": clr(25, 25), "dots": [clr(127, 127), clr(78, 156), clr(135, 255)]
}
var portion: Array[float] = []
var adds: Array[int] = []
var points: PackedVector2Array
var show_stats: bool = false
var show_hex: bool = false

func clr(rg: int, b: int) -> Color: return Color8(rg, rg, b, 255)

func set_stats(stats: Array, delta: Array) -> void:
	for p in MakeStats.hexagon():
		portion.append(min(stats[p] / float(MAX), 1))
		adds.append(delta[p])
	set_hex()
	queue_redraw()

func draw_point(point: Vector2, add: int) -> void:
	if add == 0: return
	add = min(colors.dots.size(), add)
	var dot: Color = colors.dots[add - 1]
	add = min(2, add)
	draw_rect(Rect2(point, Vector2(add, add)), dot)

func reveal_stats() -> void:
	show_stats = true
	queue_redraw()

func _draw() -> void:
	if show_hex:
		draw_colored_polygon(points, colors.polygon)
	if show_stats:
		draw_polyline(points, colors.line, 1)
		var j: int = 0
		for i in range(0, len(points), 2):
			draw_point(points[i], adds[j])
			j += 1

func set_hex() -> void:
	points = []
	var pos: Vector2 = hex_corner(0)
	points.append(pos)
	for i in range(1, sides):
		var iside: Vector2 = hex_corner(i)
		points.append(iside)
		points.append(iside)
	points.append(pos)
	show_hex = true
	
func hex_corner(i: int) -> Vector2:
	var rad: float = deg_to_rad(DEGREE * i - OFFSET)
	return centered.position + portion[i] * centered.size * Vector2(cos(rad), sin(rad))



extends PanelContainer

@onready var heroes: HFlowContainer = $margin/hero

func set_priority(level: Node, stats: Dictionary) -> void:
	for hero in heroes.get_children():
		hero.set_priority(level, stats)


extends HBoxContainer

@onready var priority: VBoxContainer = $priority
@onready var stats: VBoxContainer = $stats

func _ready() -> void: stats.hero.set_caption(name)

func set_priority(level: Node, numbers: Dictionary) -> void:
	var hero: Dictionary = level.summary.hero[name]
	var prev: Dictionary = level.prev.hero[name]
	if hero.at != prev.at:
		stats.hero.set_next_priority(priority.names[hero.at])
	priority.set_priority(prev.at, hero.of[prev.at])
	stats.number.set_stats(numbers.stats[name], numbers.prev[name])



extends VBoxContainer

@onready var caption: Label = $caption
@onready var level: Label = $level

var names: Array[String] = ["Стремление", "Выдержка", "Стойкость"]

func set_priority(at: int, lv: int) -> void:
	caption.text = names[at]
	level.text = str(lv)



extends RichTextLabel

@onready var add: MarginContainer = $add
@onready var next: MarginContainer = $next
@onready var hexagon: Control = $hexagon

#func _ready() -> void:
#	for r in [add, next, hexagon]: reveal.timeout.connect(r.reveal_stats)

func set_stats(now: Array, prev: Array) -> void:
	var stats: Dictionary = { "now": now, "delta": MakeStats.delta(now, prev) }
	# add.set_stats(stats)
	next.set_stats(stats)
	hexagon.set_stats(stats.now, stats.delta)



extends MarginContainer

@onready var offence: VBoxContainer = $stats/offence
@onready var defence: VBoxContainer = $stats/defence
@onready var points: VBoxContainer = $stats/points

func _reveal(feedback: Callable) -> void:
	for type in ["offence", "defence", "points"]:
		feedback.call(get(type))

func set_stats(stats: Dictionary) -> void:
	_reveal(func(t): t.set_stats(stats))

func reveal_stats() -> void:
	_reveal(func(t): t.reveal_stats())



extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

var now: Array[int] = [0, 0]

func set_stats(stats: Dictionary) -> void:  # ["power", "health"]
	for i in range(0, len(group)):
		now[i] = stats.now[keys[i]]
		group[i].text = str(now[i])# - stats.delta[i])

func reveal_stats() -> void:
	for i in range(0, len(group)):
		pass # TODO FIXME SEPARATOR
		# group[i].text = str(now[i])



extends VBoxContainer

@export var keys: Array[MakeStats.STAT] = []
@onready var group: Array[Node] = get_children()

func _reveal(feedback: Callable) -> void:
	for i in range(0, len(group)):
		feedback.call(i, group[i]) # .value

func set_stats(stats: Dictionary) -> void:
	_reveal(func(i, v):
		var value: int = stats.delta[keys[i]]
		v.text = str(value))

func reveal_stats() -> void:
	_reveal(func(i, v): pass  )# v.hide()) # TODO FIXME stats level up hide



extends HBoxContainer

@onready var caption: Label = get_node("caption")
@onready var next: HBoxContainer = $next
@onready var priority: Label = next.get_node("priority")

var heroes: Dictionary = { "ray": "Рей", "rock": "Рок" }

func set_caption(hero: String) -> void:
	caption.text = heroes[hero]

func set_next_priority(caption: String) -> void:
	priority.text = caption
	next.show()


extends VBoxContainer

@onready var caption: HBoxContainer = $caption
@onready var number: MarginContainer = $number
@onready var hero: HBoxContainer = $hero



extends VBoxContainer

func append(next: Label) -> void: add_child(next)


extends VBoxContainer

@onready var chat: VBoxContainer = $chat
@onready var logs: VBoxContainer = $logs
@onready var temp: VBoxContainer = $temp



extends ScrollContainer

@onready var list: VBoxContainer = $list

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)





extends PanelContainer

var _stack: HBoxContainer = null
var stack: HBoxContainer:
	get: return null # Works.upload(self, _stack, LoadBus.hints % name, name)



extends VBoxContainer

@onready var space: Control = $space
@onready var bottom: Control = $bottom


#@onready var chats: PanelContainer = $chats
#@onready var help: PanelContainer = $help



extends Control

@onready var preview: HBoxContainer = $preview




extends Button

@export var path: String = ""

func _ready() -> void:
	var chats: BoxContainer = get_node(path)
	if not chats: return
	chats.show_toggle.connect(func(state):
		visible = state)
	#print("chats: ", chats.name)
	#print("stop")
	pressed.connect(chats.show_from_panel)



extends ScrollContainer

# @onready var hints: VBoxContainer = $content/hints
@onready var books: VBoxContainer = $content/books

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return _hints

# @onready var ui: Array = hints.kind.motion.get_children()
# @onready var count: int = len(ui)
@onready var list: VBoxContainer = $list

const DOWN: float = 0.2

func down() -> void:
	create_tween().tween_property(self, "scroll_vertical", get_v_scroll_bar().max_value, DOWN)

var select: int = 0
"""
func hide_caption(no: int) -> void:
	ui[no].margin.caption.hide()

func _ready() -> void:
	for i in count:
		hide_caption(i)
		ui[i].showcase.pressed.connect(func():
			if not ui[i].helpiong:
				_change(i))

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	hide_caption(select)
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(_event: InputEvent) -> void:
	for i in [["list_up", -1], ["list_down", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
"""




extends VBoxContainer

@onready var kind: VBoxContainer = $category
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

@export var casual: bool = false

var types: Array[String]

func _ready() -> void:
	kind.fight.visible = !casual

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func clear_progress() -> void:
	for type in types:
		for ref in blackboard.g("ref")[type].values():
			if ref.visible: ref.hide_delayed()

func progress(head: String, body: String) -> void:
	behavior.tick(self, blackboard.s("head", head).s("body", body))

func get_category() -> Dictionary:
	var result: Dictionary = {}
	for i in kind.get_children():
		result[i.name] = i.get_category()
		types.append(i.name)
	return result

func set_preview(group: Node2D, prev: HelpPreview) -> void:
	var help: Dictionary = group.camera.analyze.get_analyze()
	blackboard.s("hide", true).s("show", prev.clone()).s("ref", get_category()).s(
		"progress", []).s("preview", prev.help).s("analyze", help)



extends ScrollContainer

@onready var options: VBoxContainer = $options

var scroll: int = 0

func _physics_process(_delta: float) -> void:
	scroll_vertical += scroll * 10

func _input(_event: InputEvent) -> void:
	scroll = int(Input.get_axis("list_up", "list_down"))




extends BehaviorBlackboard

func toggle_value(key: String) -> BehaviorBlackboard:
	return s(key, !g(key))


extends BehaviorAction

func resolve_showcase(body, show, preview, analyze):
	print("preview: ", preview[body], ", body: ", body, ", collide: ", analyze.has(body) and analyze[body].is_colliding())
	show[body] = preview[body]
	if show[body] and analyze.has(body):
		show[body] = analyze[body].is_colliding()

func tick(mark: Tick) -> int:
	var can_show: bool = false
	var board: BehaviorBlackboard = mark.blackboard

	var preview: Dictionary = board.g("preview")
	var show: Dictionary = board.g("show")
	var analyze: Dictionary = board.g("analyze")

	for head in preview.keys():
		for body in preview[head].keys():
			can_show = can_show or resolve_showcase(
				body, show[head], preview[head], analyze[head])
	
	return OK if can_show else FAILED



extends BehaviorAction

const EMPTY: String = ""

func tick(mark: Tick) -> int:
	var board: BehaviorBlackboard = mark.blackboard
	var head: String = board.g("head")
	if head == EMPTY: return FAILED
	
	var body: String = board.g("body")
	var ref: PanelContainer = board.g("ref")[head][body]
	ref.show_delayed()
	
	board.g("preview")[head][body] = true
	board.s("head", EMPTY).s("body", EMPTY)
	return OK



extends BehaviorAction

func tick(mark: Tick) -> int:
	if not mark.blackboard.g("hide"): return FAILED
	
	var show: Dictionary = mark.blackboard.g("ref")
	
	for head in ["motion", "action", "reason"]:
		for ref in show[head].values(): ref.hide()
		
	return OK



extends BehaviorAction

@onready var category: String = get_parent().name

func _gets(mark: Tick, key: String) -> Variant:
	return mark.blackboard.g("show")[category][name]

func tick(mark: Tick) -> int:
	if _gets(mark, "show"): _gets(mark, "ref").show()
	return OK





extends VBoxContainer

class_name HintsCategory

func get_acts() -> Array[String]:
	var acts: Array[String] = []
	for i in get_children(): acts.append(i.name)
	return acts

func get_category() -> Dictionary:
	var category: Dictionary = {}
	for act in get_acts():
		category[act] = get_node(act)
	return category


extends VBoxContainer

@onready var motion: VBoxContainer = $motion
@onready var action: VBoxContainer = $action
@onready var reason: VBoxContainer = $reason
@onready var fight: VBoxContainer = $fight
@onready var common: VBoxContainer = $common

"""
@onready var scroll: ScrollContainer = $scroll
@onready var ui: Array = scroll.get_node("stack").get_children()
@onready var count: int = len(ui)

var select: int = 0

func hide_caption(no: int) -> void:
	ui[no].margin.caption.hide()

func _ready() -> void:
	for i in count:
		hide_caption(i)
		ui[i].showcase.pressed.connect(func():
			if not ui[i].helping:
				_change(i))
		ui[i].update_hint(Def.ARRAY)

func _select_next(next: int) -> int:
	match next:
		-1: return count - 1
		count: return 0
	return next

func _change(next: int) -> void:
	hide_caption(select)
	select = _select_next(next)
	var caption: RichTextLabel = ui[select].margin.caption
	caption.show()
	caption.grab_focus()

func _input(event: InputEvent) -> void:
	for i in [["list_up", -1], ["list_down", 1]]:
		if Input.is_action_pressed(i[0]):
			_change(select + i[1])
"""




extends PanelContainer

@export var help: HelpHint

@onready var caption: Label = $stack/body/caption
@onready var head: Label = $stack/head/caption/text

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func _ready() -> void:
	head.text = help.head # TODO FIXME HELP HINT
	# caption.text = help.body % help.keyboard

func _change_state(color: Color) -> void:
	create_tween().tween_property(self, "modulate", color, 0.5)

func show_delayed() -> void:
	modulate = Color.TRANSPARENT
	show()
	_change_state(Color.WHITE)
	
func hide_delayed() -> void:
	_change_state(Color.TRANSPARENT)
	await get_tree().create_timer(1).timeout
	hide()
	modulate = Color.WHITE

func get_gamepad_hint() -> String:
	var device: String = Input.get_joy_name(0).to_lower()
	var hint: String = help.body

	if device == "": return hint % help.keyboard

	var i: int = help.get_gamepad_type(device)
	var hints: Array[String] = help.gamepad[i].hints

	if help.gamepad.size() == 1:
		hint = hint % hints[0]
	else:
		hint = hint % hints

	return hint

func sync_control_hint(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		caption.text = get_gamepad_hint()
	else:
		pass # TODO FIXME HELP 
		# caption.text = help.body % help.keyboard



extends VBoxContainer

@onready var analyze: Button = $analyze
@onready var books: Button = $books




extends Panel

@onready var borders: StyleBoxFlat = get("theme_override_styles/panel")
@onready var image: TextureRect = $image # @onready var borders: PanelContainer = $borders

const DURATION: float = 1.0 # const DURATION: float = 1.0

const animations: PackedStringArray = ["look", "rage", "grin", "smile", "amaze",
	"tired", "but", "sign", "confirm", "respect", "anger", "play", "rain"]
const keys: String = "LRGSATBNCPEYI"

func show_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.WHITE, DURATION)

func hide_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(borders, ^"modulate", Color.TRANSPARENT, DURATION)
	borders.image.stop()

func set_animation(caption: String) -> void:
	if not borders.image.playing: show_animation()
	borders.image.play(caption)

func set_environment(state: bool) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	var bg: StringName; var border: StringName
	if state: bg = &"#0f0f0f" ; border = &"#dcdcdc"
	else: bg = &"#dcdcdc" ; border = &"#0f0f0f"
	tween.tween_property(borders, ^"bg_color", Color(bg), DURATION).set_delay(DURATION)
	tween.tween_property(borders, ^"border_color", Color(border), DURATION).set_delay(DURATION)



extends Control

@onready var talk: MarginContainer = $talk
@onready var controls: MarginContainer = $controls



extends HFlowContainer

@onready var heroes: Dictionary = { "ray": $ray, "rock": $rock }




extends HBoxContainer

@export var fixed: bool = false

@onready var ray: ProgressBar = $ray/hp
@onready var rock: ProgressBar = $rock/hp
@onready var timer: Timer = $timer

var control: bool:
	set(value):
		ray.health.visible = value
		rock.health.visible = value

func select(_party: HeroParty) -> void:
	pass
	#get(party.leader.name).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#get(party.follower.name).size_flags_horizontal = Control.SIZE_FILL

func disappear() -> void:
	if not fixed: timer.disappear() #hide()
	for hero in [ray, rock]: hero.health.hide()

func change(hero: String, hp: Node) -> void:
	if not fixed: timer.appear() #show()
	
	get(hero).hp.change(hp)
	timer.start()



extends HBoxContainer

@onready var hp: ProgressBar = $hp

var _ailments: HBoxContainer = null
var ailments: HBoxContainer:
	get:
		if _ailments == null:
			_ailments = get_parent().ailments.instantiate()
			add_child(_ailments)
		return _ailments


extends ProgressBar # @export var right: bool = false

@onready var health: Label = $health
@onready var back: TextureRect = $back

const MAX: float = 0.99

var _litmus: HBoxContainer = null
var litmus: HBoxContainer:
	get:
		if _litmus == null:
			_litmus = get_parent().litmus.instantiate()
			var space: Control = $control
			space.add_sibling(_litmus)
			remove_child(space)
		return _litmus

func change(hp: Node) -> void:
	value = hp.points ; show() #health.change(hp)
	health.change(hp)
	var portion: float = hp.points / hp.maximum
	back.texture.fill_to.x = 0.07 + MAX * portion



extends MarginContainer

#@onready var status: HBoxContainer = $status
@onready var hp: HBoxContainer = $hp
