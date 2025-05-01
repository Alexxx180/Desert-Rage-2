extends Node

const DIRECTION: Vector2i = Vector2i(24, 20)
const DICT: Dictionary = {}

@onready var CHARACTER: CharacterBody2D = CharacterBody2D.new()
@onready var TEXTURE: PlaceholderTexture2D = PlaceholderTexture2D.new()
