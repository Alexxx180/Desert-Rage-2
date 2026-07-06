extends VBoxContainer

@onready var ap: ProgressBar = $ap/current
@onready var skill: MarginContainer = $skill

func use_skill(resource: Node) -> void:
	ap.use_skill(resource)
	#ap.cost.max_value = resource.maximum
	#ap.cost.value = int(resource.points)
