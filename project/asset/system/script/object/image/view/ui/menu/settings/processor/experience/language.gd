extends Node

signal update()

const AUTO: String = "auto"

var available: Array[String] = ["en", "ru"]
var language: String = AUTO # Load here language from the user settings file

func sync() -> void: update.emit()

func set_auto() -> void: _set_locale(AUTO)

func set_language(next: int) -> void: _set_locale(available[next])

func _set_locale(next: String) -> void:
	language = next
	update_locale()

func update_locale() -> void:
	var prefer: String = OS.get_locale_language()
	if language != AUTO: prefer = language
	TranslationServer.set_locale(prefer)
	sync()
