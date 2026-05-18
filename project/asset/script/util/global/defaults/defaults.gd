extends CanvasLayer

@export_group("Runtime Constants")
@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()
@export_group("Session Logic")
@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

var REF: Dictionary = {}

var game: Control:
	get: return Works.uploads(self, Def.game % "game", "game", REF, menu.connect_menu)
var pause: Control:
	get: return Works.uploads(self, Def.pause, "pause", REF, menu.connect_menu)
var settings: Control:
	get: return Works.uploads(self, Def.settings, "settings", REF, menu.connect_menu)
var information: Control:
	get: return Works.uploads(self, Def.information, "information", REF, menu.connect_menu)
var sound: Control:
	get: return Works.uploads(self, Def.sound, "sound", REF, menu.connect_menu)
var menu: Menu:
	get: return Works.loads("preserve", REF, new_menu)

var preserve: Preserves:
	get: return Works.loads("preserve", REF, new_preserve)
var skills: SkillManager:
	get: return Works.loads("skills", REF, new_skills)

var _level: Node2D
var level: Node2D:
	set(next): _level = next; _level.setup()

func new_preserve() -> Preserves: return Preserves.new()
func new_skills() -> SkillManager: return SkillManager.new()
func new_menu() -> Menu: return Menu.new()

func _ready() -> void: layer = 2 # TODO
