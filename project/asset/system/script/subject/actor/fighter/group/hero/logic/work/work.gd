extends Node

@onready var input: Node = $input
@onready var world: Node = $world
# @onready var stats: Node = $stats

var state: HeroState = HeroState.new()
var layers: Lay = Lay.new()
