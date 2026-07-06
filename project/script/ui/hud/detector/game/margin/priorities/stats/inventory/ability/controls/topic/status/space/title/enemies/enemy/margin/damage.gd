extends Label

func change(hp: Node) -> void: # text = str(int(hp.contested))
	var delta: int = hp.contested - hp.points # int(
	var op: String = "^" ; if delta < 0: op = ">"
	text = "%d %s %d" % [hp.contested, op, abs(delta)] # int()
