extends HBoxContainer

@export var fixed: bool = false

@onready var ray: ProgressBar = $ray/hp
@onready var rock: ProgressBar = $rock/hp
@onready var timer: Timer = $timer

var ailments: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/status/markers/ailments.tscn")

var control: bool:
	set(value):
		ray.health.visible = value
		rock.health.visible = value

func select(_party: HeroParty) -> void:
	pass
	#get(party.leader.name).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#get(party.follower.name).size_flags_horizontal = Control.SIZE_FILL

func disappear() -> void:
	if not fixed: timer.disappear() #hide()
	for hero in [ray, rock]: hero.health.hide()

func change(hero: String, hp: Node) -> void:
	if not fixed: timer.appear() #show()
	
	get(hero).hp.change(hp)
	timer.start()
