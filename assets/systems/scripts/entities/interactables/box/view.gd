extends Sprite2D

func switch_stand(stand: Sprite2D, status: bool) -> void:
	if stand.texture != texture:
		stand.texture = texture
	stand.visible = status
	visible = !status
