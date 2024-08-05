extends Node

@onready var hero: CharacterBody2D = get_node("../..")

@export var speed: int = 10000
@export var increase: Dictionary = {
	"left": 1, "right": 2, "backward": 4, "forward": 8
}
var mach: int = 1

func move(delta):
	var x: float = Input.get_axis("left", "right")
	var y: float = Input.get_axis("forward", "backward")
	hero.velocity = Vector2(x, y) * mach * speed * delta
	hero.move_and_slide()

func _physics_process(delta):
	if (hero.control): move(delta)

func _input(_event: InputEvent):
	if not Input.is_action_pressed("run"): return

	for action in increase:
		if Input.is_action_pressed(action):
			mach = increase[action]
	print("CURRENT MACH: ", mach)
