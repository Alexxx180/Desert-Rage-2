extends SountrackLeaf

@onready var title: Label = $margin/title

func set_title(entity: String) -> void:
	title.text = entity
