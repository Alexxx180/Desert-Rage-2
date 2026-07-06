extends Node

signal activate(pos: Vector2, type: String)

@export var act_1: String = "one"
@export var act_2: String = "two"

const COST: int = 1
var velo: VeloHero

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed(act_2): spark()
	elif Input.is_action_pressed(act_1): rain()

func animation(no: String) -> void:
	velo.fight_start()
	velo.fight_skill(no)

func torch_on() -> bool: return velo.box.logic.link.fire.on
func shield_on() -> bool: return velo.box.logic.link.spark.on

func act_tile(type: String) -> void:
	if not velo.undefined_pos() and velo.use(COST):
		activate.emit(velo.last_pos, type)
		animation(type)

func rain_box() -> void:
	if not velo.box.no_box() and torch_on() and velo.use(COST):
		velo.box.logic.work.fire.freeze()
		animation("one")

func rain() -> void: rain_box() ; act_tile(act_1)

func spark_box() -> void:
	if not velo.box.no_box() and shield_on() and velo.use(COST):
		velo.box.logic.work.spark.charge()
		animation("two")

func spark() -> void: spark_box() ; act_tile(act_2)
