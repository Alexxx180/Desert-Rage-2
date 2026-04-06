extends Node

signal activate(pos: Vector2, type: String) # signal activate(pos: Vector2, damage: int) const DAMAGE: int = 2

@onready var enemy: StaticBody2D = Defaults.STATIC # _act = _hero.to.ability.fire.ice

@export var act_1: String = "one"
@export var act_2: String = "two"

const COST: int = 1
var velo: VeloHero

var pillar: Node
var is_near: bool:
	get: return pillar.ledges.is_near()
var achievable: bool:
	get: return pillar.ledges.is_near(true)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed(act_2): whip()
	elif Input.is_action_pressed(act_1): fire()

func animation(no: String) -> void:
	velo.fight_start()
	velo.fight_skill(no)

func torch_on() -> bool: return velo.box.logic.link.fire.on

func act_tile(type: String) -> void:
	if not velo.undefined_pos() and velo.use(COST):
		activate.emit(velo.last_pos, type)
		animation(type)

func whip_enemy() -> void:
	if not velo.box.no_box() and velo.box.is_in_group("enemy") and velo.use(COST):
		print("pillar: ", pillar.name)
		pillar.dash_on_whip()
		animation("two")

func whip() -> void: whip_enemy() ; act_tile(act_2)

func fire_enemy():
	if velo.use(COST):
		animation("one")
		velo.box.logic.work.fire.ignite()
	animation("one")

func fire_box():
	if velo.no_box(): return
	if velo.box.is_in_group("enemy"):
		return fire_enemy()
	
	if not torch_on() and velo.use(COST):
		velo.box.logic.work.fire.ignite()

func fire() -> void: fire_box() ; act_tile(act_1)
