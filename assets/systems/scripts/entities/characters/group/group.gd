extends Node2D

@onready var camera: Camera2D = $camera
@onready var party: Array[CharacterBody2D] = [$ray, $rock]

var _heroes: HeroParty = HeroParty.new()
var _deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	position = _heroes.locate(party, position)
	camera.initiate(self, party, _heroes.reorder())

func _input(event) -> void:
	if event.is_action_pressed("select"):
		camera.regroup(party, _heroes.traverse())
	if event.is_action_pressed("deploy"):
		_deploy.determine(self, party, _heroes.reorder())
