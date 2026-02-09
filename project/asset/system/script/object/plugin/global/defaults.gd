extends Node

class_name Def

const DIRECTION: Vector2i = Vector2i(24, 20)
const ARRAY: Array = []
const DICT: Dictionary = {}
const INT: int = -1

static func FUNC(): pass
static func entity(o: CharacterBody2D) -> bool: return o == Defaults.ENTITY

@onready var make: Works = Works.new()

@onready var NODE: Node = Node.new()
@onready var ENTITY := CharacterBody2D.new()
@onready var STATIC := StaticBody2D.new()
@onready var TEXTURE := PlaceholderTexture2D.new()
