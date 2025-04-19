extends Node

@onready var zip: Node = $zip

func set_trunks(exporter: Node, query: ExportOST) -> void:
	exporter.selection(query.set_branch().copy().select("type").set_branch())
	exporter.selection(query.set_branch().copy().select("name").set_branch())

func set_branch(exporter: Node, query: ExportOST) -> void:
	exporter.enumerate(query.set_branch())

func set_alarm(query: ExportOST) -> void:
	var i: int = 1
	query.set_alarm()
	query.result.push_back(query.context[0])
	query.result.push_back(query.get_path(query.context[i]))
	zip.write(query.context[i], query.result[i])

func set_blend(query: ExportOST) -> void:
	query.set_branch()
	query.result.mix = query.context.mix
	query.result.set = {}
	for key in query.context.set:
		zip.insert(query, query.context.set, query.result.set, key)

func set_named(query: ExportOST) -> void:
	query.set_branch()
	for key in query.context:
		zip.insert(query, query.context, query.result, key)

func set_themes(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		zip.append(query, query.context.set, query.result.set, i))

func set_combat(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		var from: Dictionary = query.context.set[i]
		var to: Dictionary = {}
		query.result.set.push_front(to)
		for status in from: zip.insert(query, from, to, status))
