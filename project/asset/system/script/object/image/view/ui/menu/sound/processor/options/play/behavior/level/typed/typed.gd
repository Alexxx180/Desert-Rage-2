extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var levels: BehaviorSelector = $levels

@export var type: int = 0

func _ready() -> void:
	check.type = type
	levels.set_dungeons(func(l): l.type = type)

func set_ost(music: Node) -> void:
	levels.set_dungeons(func(l): l.set_ost(music))
