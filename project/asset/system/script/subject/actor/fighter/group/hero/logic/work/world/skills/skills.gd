extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, Defaults.now.world % ("skills/" + caption), caption)

var _pull: Node = null
var pull: Node:
	get: return update_act(_pull, "pull")

var _transition: Node = null
var transition: Node:
	get: return update_act(_transition, "transition")

var _act: Node = null
var act: Node:
	get: return update_act(_act, "act")

var _press: Node = null
var press: Node:
	get: return update_act(_press, "press")
