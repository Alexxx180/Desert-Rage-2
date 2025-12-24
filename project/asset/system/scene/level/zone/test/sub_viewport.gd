extends Control

@onready var subview: SubViewport = $glass/contains/subview
@onready var player: CharacterBody2D = get_node("..") # /../../../../group/ray
@onready var camera: Camera2D = subview.get_node("camera")

func _ready() -> void:
	subview.world_2d = get_tree().root.world_2d

func _physics_process(delta: float) -> void:
	camera.position = player.position
