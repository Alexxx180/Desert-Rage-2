extends Node2D

@onready var camera: Camera2D = $camera
@onready var heroes: Array[CharacterBody2D] = [$ray, $rock]

const COUNT: int = 2
var main: int = 0

func _ready() -> void:
	for hero in heroes:
		hero.position = self.position
	camera.change(self, heroes[main])
	position = Vector2.ZERO

func _input(event) -> void:
	if event.is_action_pressed("select"):
		var next: int = (main + 1) % COUNT
		for i in [main, next]:
			Processors.switch(heroes[i].logic.processors)
		camera.reset(heroes, main, next)
		main = next
