extends ParallaxLayer

@export var speed: float = 0.5

func _process(_delta: float) -> void:
	self.motion_offset = HUD.level.entity[HUD.hero].position * speed
	# self.motion_offset.x += delta * speed
