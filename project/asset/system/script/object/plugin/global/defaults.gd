extends Node

const DIRECTION: Vector2i = Vector2i(24, 20)
const DICT: Dictionary = {}
const INT: int = -1

static func FUNC(): pass

@onready var NODE: Node = Node.new()
@onready var ENTITY: CharacterBody2D = CharacterBody2D.new()
@onready var STATIC: StaticBody2D = StaticBody2D.new()
@onready var TEXTURE: PlaceholderTexture2D = PlaceholderTexture2D.new()
