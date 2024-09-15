extends Sprite2D

func switch_stand(hero: CharacterBody2D, status: bool) -> void:
	if hero.texture != texture:
		hero.texture = texture
	hero.visible = status
	visible = !status
