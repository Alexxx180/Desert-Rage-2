extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node = $logic

var movement: Callable = Defaults.FUNC

func _ready() -> void: logic.relations.controls(self)

func _physics_process(delta: float) -> void: movement.call(delta)

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion
