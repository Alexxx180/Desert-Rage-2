class_name HeroMovement extends RefCounted

enum { SPEED, MIN, MAX, INCREMENT }
enum { HOLD, RELEASE }
enum { WORLD, BORDERS, ENTITY, GROUND, TRIGGER, GAP = 7, UPLAND = 8, GRAVITY = 700000, JUMP = 200000 }

var meter: PackedFloat32Array = [1.0, 1.0, 2.25, 0.05]
var timer: Timer
var hero: int
var _hero: Node:
	get: return HUD.level.group.hero[hero]

func speeding() -> void:
	meter[SPEED] += meter[INCREMENT]
	_hero.to.moves.set_walk_speed(meter[SPEED])
	if meter[SPEED] >= meter[MAX]:
		HUD.level.states = Bit.to(HUD.level.states, RELEASE, true)
		timer.stop()
	elif meter[SPEED] >= meter[MAX] * 0.5:
		_hero.to.moves.set_running(true)

func run_hold() -> void:
	if not Bit.of(HUD.level.states, HOLD):
		_hero.state = Bit.to(_hero.state, _hero.RUN, true)
		HUD.level.states = Bit.to(HUD.level.states, HOLD, true)
		timer.start()

func run_release() -> void:
	if not Bit.of(HUD.level.states, RELEASE):
		_hero.state = Bit.to(_hero.state, _hero.RUN, false)
		HUD.level.states = 0
		meter[SPEED] = meter[MIN]
		_hero.to.moves.set_walk_speed(meter[SPEED])
		_hero.to.moves.set_running(false)
	timer.stop()

func walk(velocity: Vector2) -> void:
	_hero.add_velocity(velocity * meter[SPEED])
