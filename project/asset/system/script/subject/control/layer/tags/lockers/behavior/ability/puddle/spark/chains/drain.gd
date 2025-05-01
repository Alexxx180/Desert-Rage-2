extends Node

var chains: Node

func evaporation(map_coords: Vector2i) -> void:
	var tiles: Dictionary = chains.search.discharged_unit(chains, map_coords)
	if tiles.search: path_discharge(tiles)

func discharge(target: Vector2i, chain: int) -> void:
	var track: Rect2i = chains.get_track(chain)
	while track.position != target:
		chains.extend_size(chain)
		chains.charge.feedback(track.position, Raining.PUDDLE)
		track.position -= track.size

func diffuse_cross_unit(next_coords: Vector2i, chain: int) -> void:
	chains.drop_unit(chain)
	var direction: Vector2i = chains.get_site(chain, next_coords)
	chains.shrink_chain(chain, direction)
	chains.extend_size(chain)

func diffuse_turned_unit(next_coords: Vector2i, chain: int) -> void:
	if next_coords == chains.closing_unit(chain):
		chains.drop_unit(chain)
	chains.set_unit(chain, next_coords)
	chains.extend_size(chain)

func complex_diffuse(target: Rect2i, chain: int) -> void:
	if target.position == chains.closing_unit(chain):
		diffuse_cross_unit(target.size, chain)
	else:
		diffuse_turned_unit(target.size, chain)

func path_discharge(tiles: Dictionary) -> void:
	var chain: int = tiles.chain
	while chains.length(chain) - 1 > tiles.joint:
		discharge(chains.closing_unit(chain), chain)
		chains.drop_unit(chain)

	discharge(tiles.map_coords, chain)

	var target_coords: Vector2i = tiles.map_coords - tiles.direction
	if chains.length(chain) == 2:
		chains.set_unit(chain, target_coords)
		chains.extend_size(chain)
	else:
		complex_diffuse(Rect2i(tiles.map_coords, target_coords), chain)

	chains.charge.contact(chains.last_unit(chain))
	print("CHAINS SIZE: ", chains.size[chain])
