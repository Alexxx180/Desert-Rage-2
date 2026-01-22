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
	play.set_menu_context(menu)

func setup() -> void:
	ost.setup(self)
	play.set_ost(ost)
