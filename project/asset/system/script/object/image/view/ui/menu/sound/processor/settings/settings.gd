extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

func set_info(info: HBoxContainer, setup: Node) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)

func set_tabs(tabs: HBoxContainer, options: Node) -> void:
	tabs.restart.pressed.connect(options.play.board.reset)
