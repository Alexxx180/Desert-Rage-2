extends Control

@onready var subview: SubViewport = $glass/contains/subview
@onready var camera: Camera2D = subview.get_node(^"camera")

@onready var port: Viewport = get_viewport()

func _ready() -> void:
	subview.world_2d = get_tree().root.world_2d

func _physics_process(_delta: float) -> void:
	camera.position = HUD.level.entity[HUD.hero].position
	global_position = HUD.level.entity[HUD.hero].get_global_transform_with_canvas().get_origin() - get_canvas_transform().origin # + Vector2(0, 96)
