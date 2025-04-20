extends BehaviorSelector

@onready var hero: BehaviorAction = $hero
@onready var typed: BehaviorAction = $typed

func set_for(feedback: Callable) -> void:
	for action in [hero, typed]:
		feedback.call(action)

func set_ost(music: Node) -> void:
	set_for(func(a): a.set_ost(music))

func connect_rampage(check: Node) -> void:
	set_for(func(a): a.progress.connect(check.add_rampage))
