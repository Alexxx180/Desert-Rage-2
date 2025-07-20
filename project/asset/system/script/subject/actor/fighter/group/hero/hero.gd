extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node = $logic

var movement: Callable = Defaults.FUNC

func _ready() -> void: logic.relations.controls(self)

func _physics_process(_delta: float) -> void: movement.call()

func make_velocity(motion: Vector2) -> void: velocity = motion
