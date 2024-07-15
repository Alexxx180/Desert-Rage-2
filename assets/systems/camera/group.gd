extends Node2D

@onready var camera: Camera2D = $camera
@onready var heroes: Array = [$ray, $rock]

var count: int = 2
var main: int = 0

func _ready():
	camera.change(self, heroes[main])
	for hero in heroes:
		hero.position = self.position
	position = Vector2.ZERO

func _input(event):
	if (event.is_action_pressed("select")):
		var next: int = (main + 1) % count
		heroes[main].control = !heroes[main].control
		heroes[next].control = !heroes[next].control
		camera.change(heroes[main], heroes[next])
		main = next
