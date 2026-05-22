extends CharacterBody2D



const DAMAGE: int = 10

@onready var named: String = get_node("../..").name
@onready var group: Node2D = get_parent()
@onready var to: HeroDependency = HeroDependency.new(self)

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

var field: int
var state: PackedInt32Array = [0, 0]
var posed: Vector2
var REF: Dictionary = {}
var boxes: Array[CharacterBody2D] = []
var area: Dictionary = { "close": {}, "zone": {}, "after_tile": {}, "small_circle": {} }
var layers: Lay = Lay.new()

func do(state: String) -> bool: return Bit.of(field, get(state))
func states(bit: String, state: bool) -> void: field = Bit.to(field, get(bit), state)

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion

func update_stats() -> void: $logic.update_stats()

func controls() -> void: pass# to.topdown.actions.board.s("group", group) # logic.link.controls(VeloHero.new(self))

func _input(event: InputEvent) -> void:
	if Bit.of(field, PERSPECTIVE):
		HUD.level.platformer.input(event)
	else:
		HUD.level.topdown.input(event)

func _physics_process(delta: float) -> void:
	if Bit.of(field, PERSPECTIVE):
		HUD.level.platformer.process_physics(delta)
	else:
		HUD.level.topdown.process_physics(delta)

func is_near(hero) -> bool: return _boxes(hero).size() > 0

func encounter(_execute: TileMapLayer) -> void: HUD.level.press.encounter(self)
func diverge(_execute: TileMapLayer) -> void: HUD.level.press.diverge(self)

func _boxes(hero: CharacterBody2D) -> Array: return hero.to.world.skills.pull.boxes

func throw_effect(hero: CharacterBody2D) -> void: # THROW
	for box in _boxes(hero): box.logic.work.move.push.throw_velocity(POWER)

func apply_velocity(velocity: Vector2) -> void:
	for box in boxes:
		box.logic.work.move.apply_velocity(velocity)

func stomp_enemies() -> void: HUD.level.fight.hit(DAMAGE, area.small_circle)

func circle_enter(enemy: PhysicsBody2D) -> void:
	HUD.level.fight.enter_range(enemy, area.small_circle)

func circle_exit(enemy: PhysicsBody2D) -> void:
	HUD.level.fight.exit_range(enemy, area.small_circle)
