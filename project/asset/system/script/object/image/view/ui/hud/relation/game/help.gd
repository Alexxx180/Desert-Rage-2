extends Node

func connect_hint(hint: InputObserver, hints, act: String) -> void:
	hint.input.connect(hints.get_node(act).sync_control_hint)

func controls(hud: CanvasLayer, game: Control) -> void:
	var hint: InputObserver = hud.processor.game.help
	var hints: VBoxContainer = game.controls.preview.help.hints
	
	hint.block.hud = hints.space.preview.chats.list
	hint.block.panel = game
	hint.block.emotion.append(hints.bottom.talk)
	for hero in hud.get_node("../group").deploy.party.heroes:
		hero.to.skills.chat.body_entered.connect(func(layer: TileMapLayer):
			var tile: Dictionary = Tile.from_pos(layer, hero.position)
			var part: int = Tile.logic_no(tile.atlas)
			hint.add_chat(part)
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
