extends Node2D

@onready var camera: Camera2D = $camera
@onready var party: Array[CharacterBody2D] = [$ray, $rock]

var _heroes: HeroParty = HeroParty.new()

func _ready() -> void:
	position = _heroes.locate(party, position)
	camera.reset(self, party, _heroes.reorder())

func _input(event) -> void:
	if event.is_action_pressed("select"):
		camera.regroup(party, _heroes.traverse(party))
