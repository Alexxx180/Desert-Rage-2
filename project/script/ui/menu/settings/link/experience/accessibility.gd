extends Node

func controls(s: Node, op: HFlowContainer, work: Node) -> void:
	s.sets(op, work.experience.game.vendor, [
		["order_a", "AB", "BA"], ["order_x", "XY", "YX"],
		["reorder", "XA", "AX"], ["vendor", "SXBX", "SNTD"],
		["press", "SOFF", "SON"]])
