extends Node

const DOUBLE_COMBO: int = 2

var moves: Node

func _get_combo(stand: String) -> String:
	return "punch_combo" if stand == "hands" else "kick_combo"

func _get_act(combo: String) -> int:
	return (int(moves.tree.ask(combo)) + 1) % DOUBLE_COMBO

func fight_body(stand: String) -> void:
	var combo: String = _get_combo(stand)
	var act: int = _get_act(combo)
	moves.tree.request(combo, act)
	moves.tree.request("active", stand)

func start_fight(stand: String) -> void:
	moves.set_aggressive(stand)
	moves.stance.start()

func end_fight() -> void: moves.set_aggressive("passive")
