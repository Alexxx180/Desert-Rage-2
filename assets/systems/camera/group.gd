extends Node

@onready var camera: Camera2D = $camera
@onready var characters: Array = [$ray, $rock]

var count: int = 2
var hero: int = 0

func _ready(): camera.change(self, characters[hero])

func _input(event):
	if (event.is_action_pressed("select")):
		var next: int = (hero + 1) % count
		camera.change(characters[hero], characters[next])
		hero = next
