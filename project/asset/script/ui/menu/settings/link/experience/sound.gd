extends Node

func controls(s: Node, op: HFlowContainer, work: Node) -> void:
	s.sets(op, work.experience.game.ost, [
		["listen", "SLFL", "SLTH"], ["repeat", "SOFF", "SON"]])
