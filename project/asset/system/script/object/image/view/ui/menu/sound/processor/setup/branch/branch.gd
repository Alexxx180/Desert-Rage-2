extends Node

@onready var leafs: Node = $leafs
@onready var ui: Node = $ui

func set_blend(query: TreeOST) -> void:
	var mix: int = clampi(query.decide("mix"), 0, 100)
	leafs.set_blend(query, ui.blend, mix)
	leafs.include(query, ui.named, leafs.set_titled, "set", {})

func set_trunks(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.trunk)
	setup.selection(query.copy("right").nest_full().select("type"))
	setup.selection(query.copy("left").nest_body().select("name"))

func set_branch(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.branch[query.pad])
	setup.enumerate(query.nest_body())

func set_alarm(query: TreeOST) -> void:
	leafs.set_alarm(query, ui.alarm)

func set_named(query: TreeOST) -> void:
	leafs.include(query, ui.named, leafs.set_titled, "", {})

func set_themes(query: TreeOST) -> void:
	leafs.set_child(query, ui.mix[query.pad])
	leafs.include(query.nest_body(), ui.theme, leafs.set_theme, "set", [])

func set_combat(query: TreeOST) -> void:
	leafs.set_child(query, ui.mix[query.pad])
	leafs.include(query.nest_body(), ui.fight, leafs.set_fight, "set", [])
