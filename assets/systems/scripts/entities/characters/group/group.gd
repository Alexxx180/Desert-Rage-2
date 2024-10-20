extends Node2D

@onready var camera: Camera2D = $camera
@onready var party: Array[CharacterBody2D] = [$ray, $rock]

var _heroes: HeroParty = HeroParty.new()
var _deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	camera.deploy.is_near.connect(_deploy.set_available)
	position = _heroes.locate(party, position)
	camera.initiate(self, party, _heroes.reorder())

func _uncomfortable_position() -> bool:
	return _deploy.anchored and party[_heroes.main].logic.processors.input.platforming.jump.feet.balance.unstable

func character_select() -> void:
#	if _deploy.anchored and party[_heroes.main].logic.processors.input.platforming.jump.feet.balance.unstable:
		#return
	var order: Vector2i = _heroes.traverse(_heroes.reorder())
	_deploy.select(party, order)
	camera.regroup(party, order)

func _input(event) -> void:
	if _uncomfortable_position():
		return

	if event.is_action_pressed("select"):
		character_select()
	if event.is_action_pressed("deploy"):
		var order: Vector2i = _heroes.reorder()
		_deploy.determine(party, order)
