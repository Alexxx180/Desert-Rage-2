extends BehaviorSequence

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]

var caption: int:
	set(value): set_ambient(func(a): a.caption = value)
var type: int:
	set(value): set_ambient(func(a): a.type = value)

func set_ambient(feedback: Callable) -> void:
	for status in rampage:
		feedback.call(status)

func set_ost(music: Node) -> void:
	set_ambient(func(a): a.set_ost(music))
