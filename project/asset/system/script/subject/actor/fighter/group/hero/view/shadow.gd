extends Sprite2D

var hanging: bool:
	set(value):
		if value: hang()
		else: stand()

func stand() -> void: position = Vector2(0, -5)
func hang() -> void: position = Vector2(0, 27)

func climb_start() -> void: visible = false
func climb_end() -> void: visible = true
