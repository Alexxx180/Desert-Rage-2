extends Node2D

@export var deployed: bool = true

@onready var camera: Camera2D = $camera
@onready var party: Array[CharacterBody2D] = [$ray, $rock]
@onready var _heroes: HeroParty = HeroParty.new()
@onready var _deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	var order: Vector2i = _heroes.reorder()
	camera.deploy.is_near.connect(_deploy.set_available)
	position = _heroes.locate(party, position)
	camera.initiate(self, party, order)

	if deployed:
		_deploy.set_available(true)
		_deploy_heroes(order)

func _get_feet(i: int) -> int:
	return party[i].logic.processors.environment.floors.queue.F

func _comfortable_position() -> bool:
	#print("deploy anchored: ", _deploy.anchored)
#	var stable: bool = true
#	var i: int = 2
	var f1: int = _get_feet(0)
	var f2: int = _get_feet(1)

	return f1 == f2 # and f1.balance.stable and f2.balance.stable

#	while i > 0 and stable:
#		i -= 1
#		stable = stable and _get_feet(i).balance.stable
#	return stable
	#return party[_heroes.main].logic.processors.input.platforming.jump.feet.balance.stable
#	return _deploy.anchored and party[_heroes.main].logic.processors.input.platforming.jump.feet.balance.unstable

func character_select() -> void:
	var order: Vector2i = _heroes.traverse(_heroes.reorder())
	_deploy.select(party, order)
	camera.regroup(party, order)

func _deploy_heroes(order: Vector2i) -> void:
	_deploy.determine(party, order)

func _input(event) -> void:
	#if _uncomfortable_position(): return

	if event.is_action_pressed("select"):
		character_select()
	if event.is_action_pressed("deploy") and _comfortable_position():
		_deploy_heroes(_heroes.reorder())
