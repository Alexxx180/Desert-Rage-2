extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

var setup: Node

func set_info(info: HBoxContainer) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)
