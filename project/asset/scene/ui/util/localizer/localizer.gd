extends Node

@onready var caption: RichTextLabel = get_parent().get_locale()
@onready var locale: String = caption.text
@export var keys: Array[String] = ["KAL+KAU+KAD+KAR", "KB"]

func merge_controls(help: String) -> String:
	if not help.contains("+"): return tr(help)
	
	var result: String = ""
	for text in help.split("+"): result += tr(text)
	return result

func update_locale() -> void:
	var result: Array[String] = []
	for key in keys: result.append(merge_controls(key))
	caption.text = tr(locale) % result

func _ready() -> void: update_locale()
