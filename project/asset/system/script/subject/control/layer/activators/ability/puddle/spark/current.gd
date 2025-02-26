extends Node

var sources: Array[Array] = [] # Vector2i
var length: Array[int] = []
var size: int = 0

func check(): pass

func fire_drain() -> void:
	pass

func compare_edge() -> void:
	pass

func connection(map_coords: Vector2i) -> void:
	for i in size:
		var j: int = length[i]
		var path: Array[Vector2i] = sources[i]
		var dir: Vector2i = path[j] - path[max(j - 1, 0)]
		if dir == Vector2i.ZERO:
			path.append(map_coords)
		else:
			compare_edge()

func charge() -> void:
	pass
