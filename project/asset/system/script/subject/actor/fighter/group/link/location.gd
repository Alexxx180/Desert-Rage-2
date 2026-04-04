extends Node

var work: Node
var root: LevelRoot

func open_chests(hero: CharacterBody2D) -> void:
	work.chests.open_chests(hero)

func recovery(hero: CharacterBody2D) -> void:
	work.recovery.recover(hero)

func activate(pos: Vector2):
	var tile: Dictionary = root.border.from_pos(pos).context
	if tile.coords == Def.VECTI: return # print("ATLAS, P: ", tile.atlas)#, " - N: ", atlas)
	
	if work.chests.is_chest(tile.atlas): # TODO FIX 5 0
		return work.chests.open_chests()
	
	if work.lockers.activator.search.storage.has_trigger(tile.coords):
		return work.lockers.activator.activate_trigger(tile.coords)
