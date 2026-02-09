extends Node

@onready var sound: Node = $sound
@onready var interface: Node = $interface
@onready var game: Node = $game
@onready var accessibility: Node = $accessibility

func controls(ui: Control, see: Control, work: Node) -> void:
	var xp: VBoxContainer = see.topics.options.game.experience
	var main: VBoxContainer = ui.game.priorities.stats.inventory.ability.controls
	
	for i in ["pplayer", "pinterface"]:
		work.experience.interface.logic.get(i).s = work.experience.store
	for i in [interface, game]: i.s = work.experience.store
	
	game.controls(xp.experience.options, main, work)
	interface.controls(xp.interface.options, main, work)
	sound.controls(work.experience.store, xp.sound.options, work)
	accessibility.controls(work.experience.store, xp.accessibility.options, work)
