extends Node

func _p(title: String) -> String: return LoadBus.ability % title
func update_act(ref: Node, caption: String) -> Node: return Works.upload(self, ref, _p(caption), caption)

var has_sources: bool = false
var lockers: Lockers

var _flow: FlowConductor = null
var flow: FlowConductor:
	get: return Works.inits(self, _flow, "flow", get_flow)

func get_flow() -> FlowConductor:
	_flow = FlowConductor.new()
	_flow.root = lockers.root
	_flow.flow.connect(puddle_charge)
	return _flow

var rain: Node:
	get: return Works.uploads(self, _p("rain"), "rain", set_conductor)
var spark: Timer:
	get: return Works.uploads(self, _p("spark"), "spark", set_conductor)
var chains: Node:
	get: return Works.uploads(rain, _p("chains"), "chains", set_chains)
var freeze: Node:
	get: return Works.uploads(self, _p("freeze"), "freeze", set_freeze)

func set_conductor(_rain: Node) -> void: _rain.conductor = flow

func set_chains(_chains: Node) -> void:
	_chains.set_conductor(flow)
	_chains.charge.activate(lockers.activator.map_activate)

func set_freeze(_freeze: Node) -> void:
	_freeze.root = lockers.root
	if has_sources: _freeze.fire_drain.connect(evaporation)

func evaporation(map_coords: Vector2i) -> void: chains.drain.evaporation(map_coords)

func activate_puddle(pos: Vector2) -> void: flow.activate_puddle(self, pos)

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if spark.not_in_spark(map_coords):
		chains.charge.from_puddle(map_coords, no)
