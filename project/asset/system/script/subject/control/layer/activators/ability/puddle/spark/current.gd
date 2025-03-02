extends Node

const ID: int = 2
var tiles = {
	"PUDDLE": Vector2i(0, 2), "SOURCE": Vector2i(2, 2),
	"SPARK": [Vector2i(1, 2), Vector2i(1, 3)]
}

var count: int = 0
var _execute: TileDecorator
var execute: TileDecorator:
	get: return _execute
	set(value):
		_execute = value
		charge.execute = value
		chains.initiate(execute.busy(tiles.SOURCE, ID))

@onready var drain: Node = $drain
@onready var charge: Node = $charge
@onready var chains: Node = $chains

func _ready() -> void:
	drain.flow = self
	charge.flow.connect(puddle)

func at_edge(previous: Rect2i) -> bool:
	return execute.context.coords - previous.position == previous.size

func puddle(map_coords: Vector2i, no: int = 0) -> void:
	execute.select(tiles.SPARK[no], ID)
	if no == 1:
		chains.initiate_source(map_coords)
		connection(chains.last_chain(), map_coords)
		return
	
	var chain: int = chains.search_path(map_coords)
	if chain != -1: connection(chain, map_coords)

func connection(chain: int, map_coords: Vector2i) -> void:
	execute.target(map_coords)
	var track: Rect2 = chains.get_track(chain)

	if track.size == Vector2.ZERO:
		chains.set_unit(chain, map_coords)
		print("START!!")
		execute.paint()
		touch(map_coords)
	elif at_edge(track):
		chains.extend_chain(chain, track.size)
		print("AT EDGE!!")
		execute.paint()
		touch(map_coords)
	elif map_coords != chains.last_unit(chain):
		chains.add_unit(chain, map_coords)
		execute.paint()
		touch(map_coords)

func drop(track: Rect2i, target: Vector2i, chain: int) -> void:
	#print("[PAINT]")
	while track.position != target:
		execute.erase(track.position)
		# execute.target(current[chain][B]).select(tiles.PUDDLE).paint()
		#print("[PAINT]", track.position, " > ", track.size, " > ", target)
		track.position -= track.size
	#print("LOOP END 2")

func release(map_coords: Vector2i, direction: Vector2i, chain: int, joint: int) -> void:
	var track: Rect2i
	
	#print("TRY [REMOVE]: CURRENT = ", chain, " UNIT = ", joint)
	while chains.length(chain) - 1 > joint:
		track = chains.get_track(chain)
		drop(track, chains.closing_unit(chain), chain)
		chains.drop_unit(chain)
	#print("LOOP END")
	
	#print("AFTER [REMOVE]: CURRENT = ", chain, " UNIT = ", joint)
	track = chains.get_track(chain)
	drop(track, map_coords, chain)
	
	var target_coords: Vector2i = map_coords - direction
	print("TARGET COORDS: ", target_coords, ", UNIT: ", chains.closing_unit(chain))
	#chains.get_unit(chain, joint - 1))
	
	if chains.length(chain) == 2:
		chains.set_unit(chain, target_coords)
		"""
		direction = chains.get_direction(target_coords - chains.closing_unit(chain))
		chains.set_unit(chain, target_coords - direction)
		"""
	else:
		#direction = chains.get_direction(map_coords - chains.last_unit(chain))
		
		#direction = Vector2i.ZERO
		#chains.extend_chain(chain, direction)
		#"""
		#if map_coords == chains.last_unit(chain):
	#		direction = chains.get_direction(chains.last_unit(chain) - chains.last_unit(chain))
		if map_coords == chains.closing_unit(chain):
			chains.drop_unit(chain)
			direction = chains.get_site(chain, target_coords)
			#direction = chains.get_direction(target_coords - chains.closing_unit(chain))
			print("DIR > ", direction)
			chains.extend_chain(chain, direction * -1)
		else:
			if target_coords == chains.closing_unit(chain):
				chains.drop_unit(chain)
			chains.set_unit(chain, target_coords)
		#"""
		#chains.set_unit(chain, target_coords - direction)
		#chains.set_unit(chain, target_coords)
	"""
	elif target_coords == chains.closing_unit(chain): #chains.get_unit(chain, joint - 1)# and chains.length(chain) > 2:
		print("CHAIN CLOSING: ", chains.closing_unit(chain))
		#var cross: bool = target_coords == chains.closing_unit(chain)
		chains.drop_unit(chain)
		#print("CHAIN LEN: ", chains.length(chain))
		#if chains.length(chain) == 2:
		#if target_coords == 
		#if cross:
		direction = chains.get_direction(target_coords - chains.closing_unit(chain))
		chains.set_unit(chain, target_coords - direction)
		#chains.set_unit(chain, target_coords)
		#else:
		#	direction = chains.get_direction(target_coords - chains.closing_unit(chain))
		#	chains.set_unit(chain, target_coords - direction)
		"""


	touch(chains.last_unit(chain))

func touch(map_coords: Vector2i) -> void:
	#print("EXECUTING: ", map_coords)
	charge.contact(map_coords)
