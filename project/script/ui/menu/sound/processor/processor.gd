extends Node

@onready var settings: Node = $settings
@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	settings.set_info(detector.settings.info, setup)
	settings.set_tabs(detector.settings.tabs, options)
	setup.set_soundtrack(options, detector)



extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

func set_info(info: VBoxContainer, setup: Node) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)

func set_tabs(tabs: VBoxContainer, options: Node) -> void:
	for o in [tabs.play, tabs.edit]: # TODO SET TABS
		o.pressed.connect(options.ost.switch_mode)


extends Node

@onready var operation: Node = $operation
@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

var ui: Dictionary

func op(key: String, entry: Dictionary, leaf: Control) -> void:
	operation.get("set_" + key + "_theme").call(self, entry, leaf)

func set_leaf_theme(e: Dictionary, l: Control) -> void: op("leaf", e, l)
func set_ambient_theme(e: Dictionary, l: Control) -> void: op("ambient", e, l)
func set_named_theme(e: Dictionary, l: Control) -> void: op("named", e, l)
func set_standalone(e: Dictionary, l: Control) -> void: op("standalone", e, l)
func set_blend_theme(e: Dictionary, l: Control) -> void: op("blend", e, l)
func set_theme_context(theme: OpenThemeDialog) -> void:
	add.context = theme
	search.theme = theme

func set_operations(menu: VBoxContainer) -> void:
	set_theme_context($theme)
	ost.setup_modes(self, menu)
	# play.set_menu_context(menu) # TODO FIXME SET MENU CONTEXT

func setup() -> void:
	ost.setup(self)
	play.set_ost(ost)




extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

var _ui: VBoxContainer
var _options: Node

func selection(query: TreeOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: TreeOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func setup() -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: TreeOST = TreeOST.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(_ui.dropdown)
		query.set_ui_tree(_options.ui)
		enumerate(query)
		_options.setup()

func _reload() -> void:
	for leaf in _ui.dropdown.get_children():
		_ui.dropdown.remove_child(leaf)
		leaf.queue_free()
	setup()

func reset() -> void:
	SoundtrackSystem.reset()
	_reload()

func reimport() -> void:
	SoundtrackSystem.reimport()
	_reload()

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	_options = options
	_ui = ui
	setup()
	if SoundtrackSystem.is_valid("music"):
		options.set_operations(_ui)


extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Alarm: ", query.caption)
	mark.actor.branch.set_alarm(query)
	return OK



extends BehaviorAction

func exist(mark: Tick) -> bool:
	var context: Variant = mark.blackboard.get_value("query").context
	return context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark) else FAILED




extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	return OK if query.context.set is Array else FAILED




extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set.size() > 0 and data.set[0] is Dictionary

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Combat: ", query.caption)
	mark.actor.branch.set_combat(query)
	return OK





extends BehaviorAction

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Themes: ", query.caption)
	mark.actor.branch.set_themes(query)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark)






extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary and data.mix is float

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Blend: ", query.caption)
	mark.actor.branch.set_blend(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Dictionary and data.values()[0] is String

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Named: ", query.caption)
	mark.actor.branch.set_named(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Trunk: ", query.caption)
	mark.actor.branch.set_trunks(mark.actor, query)
	return OK





extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Branch: ", query.caption)
	mark.actor.branch.set_branch(mark.actor, query)
	return OK





extends Node

@onready var leafs: Node = $leafs
@onready var ui: Node = $ui

func set_blend(query: TreeOST) -> void:
	leafs.set_blend(query, ui.blend)
	leafs.include(query, ui.named, leafs.set_titled, "set", {})

func set_trunks(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.trunk)
	setup.selection(query.copy("right").nest_full().select("type"))
	setup.selection(query.copy("left").nest_body().select("name"))

func set_branch(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.branch[query.pad])
	setup.enumerate(query.nest_body())

func set_alarm(query: TreeOST) -> void:
	leafs.set_alarm(query, ui.alarm)

func set_named(query: TreeOST) -> void:
	leafs.include(query, ui.named, leafs.set_titled, "", {})

func set_themes(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.theme, leafs.set_theme, "set", [])

func set_combat(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.fight, leafs.set_fight, "set", [])







extends Node

func append_child(query: TreeOST, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func set_child(query: TreeOST, child) -> Control:
	var caption: String = query.caption
	var branch: Control = append_child(query, child, true)
	branch.name = caption
	branch.caption = caption
	return branch

func set_theme(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(track)
	query.ui_tree.set.push_back(branch)

func set_fight(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	for status in track:
		var theme: String = track[status].track if track[status] is Dictionary else track[status]
		branch.content[status].set_metadata(theme)
	query.ui_tree.set.push_back(branch)

func set_titled(query, child, tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(tracks[track])
	branch.set_title(track)
	query.ui_tree.set[track] = branch

func set_mix(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	# query.set_ui(branch.content.themes.body)

func set_blend(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	query.set_ui(branch.content.themes.body)

func set_alarm(query: TreeOST, child) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(query.context)
	query.ui_tree.set = branch

func include(query, child, setter, list, init) -> void:
	var tracks: Variant = query.context if list == "" else query.decide(list)
	query.ui_tree.set = init
	for track in tracks:
		setter.call(query, child, tracks, track)




class_name SoundtrackUI extends RefCounted

var theme: PackedScene = preload("res://pre/ui/ost/leaf/leaf.tscn")
var fight: PackedScene = preload("res://pre/ui/ost/leaf/combat.tscn")
var alarm: PackedScene = preload("res://pre/ui/ost/leaf/alarm.tscn")
var named: PackedScene = preload("res://pre/ui/ost/leaf/named.tscn")

var trunk: PackedScene = preload("res://pre/ui/ost/trunk.tscn")
var branch: PackedScene = preload("res://pre/ui/ost/branch.tscn")
var blend: PackedScene = preload("res://pre/ui/ost/blend.tscn")
var mix: PackedScene = preload("res://pre/ui/ost/mix.tscn")
