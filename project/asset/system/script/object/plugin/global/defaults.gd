extends Node

const DIRECTION: Vector2i = Vector2i(24, 20)
const DICT: Dictionary = {}
const INT: int = -1

@onready var CHARACTER: CharacterBody2D = CharacterBody2D.new()
@onready var STATIC: StaticBody2D = StaticBody2D.new()
@onready var TEXTURE: PlaceholderTexture2D = PlaceholderTexture2D.new()
