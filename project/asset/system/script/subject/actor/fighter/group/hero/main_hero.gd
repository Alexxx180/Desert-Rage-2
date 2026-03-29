extends CharacterBody2D

@onready var group: Node2D = get_parent()
@onready var to: HeroDependency = HeroDependency.new(self)

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion

func _ready() -> void:
	logic.link.controls(self)
	to.topdown.actions.board.s("group", group)
