extends MarginContainer

@onready var stack: HFlowContainer = $score/stack
@onready var heroes: Dictionary = { "ray": stack.get_node("ray"), "rock": stack.get_node("rock") }
