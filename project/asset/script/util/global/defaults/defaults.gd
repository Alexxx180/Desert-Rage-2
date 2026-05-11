extends CanvasLayer

@export_group("Runtime Constants")
@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()
@export_group("Session Logic")
@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

var game: Control:
	get: return Works.uploads(self, Def.game % "game", "game", menu.connect_menu)
var pause: Control:
	get: return Works.uploads(self, Def.pause, "pause", menu.connect_menu)
var settings: Control:
	get: return Works.uploads(self, Def.settings, "settings", menu.connect_menu)
var information: Control:
	get: return Works.uploads(self, Def.information, "information", menu.connect_menu)
var sound: Control:
	get: return Works.uploads(self, Def.sound, "sound", menu.connect_menu)

var REF: Dictionary = {}
var menu: Menu = Menu.new()
var level: Node2D

func set_group() -> void:
	stats.save_progress()

func _ready() -> void:
	set_group() # TODO
	layer = 2

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()
