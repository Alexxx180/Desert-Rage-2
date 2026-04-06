class_name Def extends Node

const DIRECTION: Vector2i = Vector2i(24, 20)
const VECTI: Vector2i = Vector2i(-1, -1)
const ARRAY: Array = []
const DICT: Dictionary = {}
const INT: int = -1

static func vec2() -> Array: return [Vector2.AXIS_X, Vector2.AXIS_Y]
static func truth(_empty: Object) -> bool: return true # combined with implicit func for readability
static func FUNC(): pass
static func entity(o: CharacterBody2D) -> bool: return o == Defaults.ENTITY
static func ic(text: String, result: Variant) -> Variant: print(text % result) ; return result
static func ics(text: String, state: Array = Defaults.ARR) -> Variant: print(text % state) ; return state[0]

@onready var pre: PreloadBus = PreloadBus.new()

# @onready var make: Works = Works.new()

@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()
