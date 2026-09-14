extends Button

@onready var image: TextureRect = $margin
@onready var count: Label = $margin

var default: Label
var select: TextureRect

func _ready() -> void:
	if has_node(^"select"): select = get_node(^"select")
	elif has_node(^"default"): default = get_node(^"default")
