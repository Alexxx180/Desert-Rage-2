extends Control

@onready var fps: Label = $count

func _process(_delta: float) -> void:
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
