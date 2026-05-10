class_name Def extends CanvasLayer

@export var progress: HelpPreview

@onready var xp: Node = $xp

var game: Control:
	get: return Works.uploads(self, LoadBus.game % "game", "game")
var pause: Control:
	get: return Works.uploads(self, LoadBus.pause, "pause")
var settings: Control:
	get: return Works.uploads(self, LoadBus.settings, "settings")
var information: Control:
	get: return Works.uploads(self, LoadBus.information, "information")
var sound: Control:
	get: return Works.uploads(self, LoadBus.sound, "sound")
var level: Node2D

var menu: Menu = Menu.new()

func set_group() -> void:
	stats.save_progress()
	#group
	# game.set_preview(group, progress)

func set_transitions() -> String:
	settings.link.controls(game.see)
	return """
	game.set_transitions({ "settings": settings,
		"information": information }, get_node("../ost"))
	information.set_transition(game)
	sound.set_settings_transition(settings)
	settings.set_transitions(game, sound)
	"""

func _ready() -> void:
	set_group() # TODO
	layer = 2
	# set_transitions()

func reset() -> void:
	game.detector.game.show()
	game.detector.pause.hide()
	settings.hide()

func set_pause() -> void:
	pause = load(LoadBus.hud % "pause").instantiate()

const DIRECTION: Vector2i = Vector2i(24, 20)
const VECTI: Vector2i = Vector2i(-1, -1)
const ARRAY: Array = []
const DICT: Dictionary = {}
const INT: int = -1

var REF: Dictionary = {}

@export_group("Runtime Constants")
@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()

@export_group("Session Logic")
@onready var ost: SoundtrackSystem = SoundtrackSystem.new()
@onready var stats: SessionStats = SessionStats.new(get_tree())

static func FUNC(): pass
static func among(from: float, x: float, to: float) -> bool: return (from <= x) and (x <= to)
static func vec2() -> Array: return [Vector2.AXIS_X, Vector2.AXIS_Y]
static func vec2i(axis: int) -> Vector2i: return Vector2i(axis, axis)
static func truth(_empty: Object) -> bool: return true # combined with implicit func for readability
static func entity(o: CharacterBody2D) -> bool: return o == HUD.ENTITY
static func ic(text: String, result: Variant) -> Variant: print(text % result) ; return result
static func ics(text: String, state: Array = Def.ARRAY) -> Variant: print(text % state) ; return state[0]
