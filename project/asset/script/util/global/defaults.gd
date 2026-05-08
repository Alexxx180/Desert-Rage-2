class_name Def extends CanvasLayer

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

static func among(from: float, x: float, to: float) -> bool: return (from <= x) and (x <= to)
static func vec2() -> Array: return [Vector2.AXIS_X, Vector2.AXIS_Y]
static func vec2i(axis: int) -> Vector2i: return Vector2i(axis, axis)
static func truth(_empty: Object) -> bool: return true # combined with implicit func for readability
static func FUNC(): pass
static func entity(o: CharacterBody2D) -> bool: return o == HUD.ENTITY
static func ic(text: String, result: Variant) -> Variant: print(text % result) ; return result
static func ics(text: String, state: Array = Def.ARRAY) -> Variant: print(text % state) ; return state[0]
