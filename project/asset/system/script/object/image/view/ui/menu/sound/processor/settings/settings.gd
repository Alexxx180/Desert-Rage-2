extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

func set_info(info: VBoxContainer, setup: Node) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)

func set_tabs(tabs: VBoxContainer, options: Node) -> void:
	for o in [tabs.play, tabs.edit]: # TODO SET TABS
		o.pressed.connect(options.ost.switch_mode)
