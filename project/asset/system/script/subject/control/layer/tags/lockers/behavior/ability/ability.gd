extends Node

func _p() -> String: return "res://asset/system/scene/level/zone/build/tilemap/tags/lockers/ability/%s.tscn"
func update_act(ref: Node, caption: String) -> Node: return Works.upload(self, ref, _p() % caption, caption)

var has_sources: bool = false
var lockers: Lockers

var _flow: FlowConductor = null
var flow: FlowConductor:
	get:
		if _flow == null:
			_flow = FlowConductor.new()
			_flow.root = lockers.root
			_flow.flow.connect(puddle_charge)
		return _flow

var _rain: Node = null
var rain: Node:
	get:
		if _rain == null:
			var title: String = "rain"
			_rain = load(_p() % title).instantiate()
			_rain.name = title
			_rain.conductor = flow
			add_child(_rain)
		return _rain

var _spark: Node = null
var spark: Node:
	get:
		if _spark == null:
			var title: String = "spark"
			_spark = load(_p() % title).instantiate()
			_spark.name = title
			_spark.conductor = flow
			add_child(_spark)
		return _spark

var _chains: Node = null
var chains: Node:
	get:
		if _chains == null:
			var title: String = "chains"
			_chains = load(_p() % title).instantiate()
			_chains.name = title
			_chains.set_conductor(flow)
			_chains.charge.activate(lockers.activator.map_activate)
			rain.add_child(_chains)
		return _chains

var _freeze: Node = null
var freeze: Node:
	get:
		if _freeze == null:
			_freeze = load(_p() % "freeze").instantiate()
			_freeze.root = lockers.root
			add_child(_freeze)
			if has_sources: _freeze.fire_drain.connect(evaporation)
		return _freeze

func evaporation(map_coords: Vector2i) -> void: chains.drain.evaporation(map_coords)

func activate_puddle(pos: Vector2) -> void: flow.activate_puddle(self, pos)

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if spark.not_in_spark(map_coords):
		chains.charge.from_puddle(map_coords, no)
