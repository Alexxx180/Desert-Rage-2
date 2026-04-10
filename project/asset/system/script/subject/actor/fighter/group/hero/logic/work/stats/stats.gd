extends Node

func update_act(ref: Node, caption: String) -> Node: return Works.upload(self, ref, Defaults.now.health % caption, caption)

var _aura: Node = null
var aura: Node:
	get: return update_act(_aura, "aura")

var _resource: Node = null
var resource: Node:
	get: return update_act(_resource, "resource")

var state: HeroState = HeroState.new()
