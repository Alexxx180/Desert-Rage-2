extends HBoxContainer

@export var fixed: bool = false

@onready var ray: ProgressBar = $ray
@onready var rock: ProgressBar = $rock
@onready var timer: Timer = $timer

func select(party: HeroParty) -> void:
	get(party.leader.name).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	get(party.follower.name).size_flags_horizontal = Control.SIZE_FILL

func disappear() -> void:
	if not fixed: timer.disappear() #hide()
	for hero in [ray, rock]: hero.health.hide()

func change(hero: String, hp: Node) -> void:
	if not fixed: timer.appear() #show()
	
	get(hero).change(hp)
	timer.start()
