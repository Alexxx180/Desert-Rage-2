extends Node

var view: Node2D
var whip: Node2D
var pillars: Node2D
var floors: Node
var layers: Lay
var chains: Node# 2D
var levels: Node
var teleport: Node

var rotation: Dictionary = {
	Vector2i(1, 0): 0, Vector2i(-1, 0): 180, 
	Vector2i(0, 1): 90, Vector2i(0, -1): -90 }

func whip_dash(pos: Vector2) -> void:
	teleport.dash(pos, "whip_dash")

func whip_catch(pos: Vector2) -> void:
	if pos.x != 0: return
	teleport.dash(pos, "go")
	view.animation.moves.set_hang_move("whip_dash")

func rotate(pos: Vector2, jump_offset: float) -> Vector2:
	view.whip.rotation_degrees = rotation[pillars.dir]
	return pos + jump_offset * pillars.dir
