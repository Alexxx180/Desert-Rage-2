extends Sprite2D

func switch_stand(stand: Sprite2D, status: bool) -> void:
	if stand.texture != texture:
		stand.texture = texture
	stand.visible = status
	visible = !status

func standing(_seat: Node, hero: CharacterBody2D) -> void:
	var stand: Sprite2D = hero.view.stand
	if stand.texture != texture:
		stand.texture = texture
	visible = false

func leaving(_seat: Node, _hero: CharacterBody2D) -> void:
	visible = true
