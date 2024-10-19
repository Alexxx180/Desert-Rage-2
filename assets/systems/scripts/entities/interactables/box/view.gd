extends Sprite2D

func switch_stand(stand: Sprite2D, status: bool) -> void:
	if stand.texture != texture:
		stand.texture = texture
	stand.visible = status
	visible = !status

func standing(stand: Sprite2D) -> void:
	if stand.texture != texture:
		stand.texture = texture
	visible = false

func leaving() -> void:
	visible = true
