extends Node

var panel: VBoxContainer
var hint: InputObserver

func connect_hint(hints, act: String) -> void:
	hint.input.connect(hints.get_node(act).sync_control_hint)

func connect_stats(stack: Container) -> void:
	stack.chats.chat = panel
	stack.chats.add_child(panel)

func controls(hud: CanvasLayer, game: Control) -> void:
	hint = hud.processor.game.help
	panel = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/gameplay/chats/chat.tscn").instantiate()
	hint.block.panel = panel
	game.priorities.stats.topic.loaded.connect(connect_stats)
	
	# var hints: VBoxContainer = game.controls.hints.space.preview.help.hints
	# hint.block.panel = game.priorities.stats.topic.stack.chats.chat
	
	# TODO FIXME HUD LINK
	# hint.block.hud = game.controls.hints.space.preview.chats.list
	# hint.block.emotion.append(game.controls.hints.bottom.talk)
	
	var group: Node2D = hud.get_node("../../group")
	# for hero in .deploy.party.heroes: TODO FIXME all group need to listen dialog
	group.ray.to.skills.chat.body_entered.connect(func(layer: TileMapLayer):
		var tile: Dictionary = Tile.from_pos(layer, group.ray.position)
		var part: int = Tile.logic_no(tile.atlas)
		hint.dialog.add_chat(part)
		Tile.erase_area(layer, Tile.used_cells(layer, tile.atlas)))

	# priorities/stats/inventory/ability/back/vertical
	# var hints: VBoxContainer = hud.detector.game.hints

	# TODO FIXME CATEGORY NEED TO CREATE SINGLE SHOW HIDE BUTTON
	# hint.input.connect(analyze.short.sync_control_hint)
	#var analyze: Button = game.controls.topic.status.preset.sets.skill.analyze
	#analyze.pressed.connect(hints.toggle_help)
	
	#for button in game.hints.get_node("group").get_children():
	#	button.toggled.connect(func(off: bool):
	#		game.hints.help[button.name].visible = !off)

	""" sync control hint behavior changed
	connect_hint(hint, hints.kind.action, "act")
	for act in ["move", "push"]:
		connect_hint(hint, hints.kind.motion, act)
	for act in ["team", "group"]:
		connect_hint(hint, hints.kind.reason, act)
	# """
	#hint.show_help(true)0.1
