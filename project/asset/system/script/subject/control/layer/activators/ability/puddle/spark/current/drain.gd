extends Node

var flow: Node

func evaporation(map_coords: Vector2i) -> void:
	var search: bool = true
	var chain: int = flow.chains.current.size()
	var joint: int
	
	print("SEARCHING")
	while chain > 0 and search:
		chain -= 1
		joint = flow.chains.length(chain)
		print("CHAIN: ", chain)
		while joint > 1 and search:
			joint -= 1
			print("JOINT: ", joint)
			search = not flow.chains.between(map_coords, chain, joint)
	print("STUCK")

	if not search:
		var direction: Vector2i = flow.chains.get_site(chain, joint, map_coords)
		print("FIND: ", chain, " - ", joint, " , DIRECTION: ", direction)
		flow.release(map_coords, direction, chain, joint)
