extends ParallaxBackground

@export var speed: float = 0.5
@onready var back: Array[Node] = get_children()

func _process(_delta: float) -> void:
	for lay in back: lay.motion_offset = HUD.level.entity[HUD.hero].position * speed
