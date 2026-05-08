class_name VeloHero extends RefCounted

var box: CharacterBody2D
var hero: CharacterBody2D
var deploy: DeploymentRaycast
var root: LevelRoot
var state: Dictionary = { "position": Vector2.ZERO, "height": 0, "weight": 0 }
var last_pos: Vector2

func _init(h: CharacterBody2D) -> void: hero = h

func use(cost: int) -> bool: return hero.to.resource.use(cost)
func no_box() -> bool: return box == HUD.ENTITY
func undefined_pos() -> bool: return last_pos == Vector2.ZERO

func far_map() -> void: last_pos = Vector2.ZERO
func near_map(act: Node2D) -> void: last_pos = hero.position + act.position
func near_box(vessel: CharacterBody2D) -> void: box = vessel
func far_box(_vessel: CharacterBody2D) -> void: box = HUD.ENTITY

func animate(motion: Vector2) -> void: hero.view.move(motion)
func make(motion: Vector2) -> void: hero.make_velocity(motion)
func forget() -> void: make(Vector2.ZERO)
func set_position(pos: Vector2) -> void: hero.position = pos
func get_ground() -> Vector2: return hero.position + deploy.walls.target

func decide(motion: Vector2) -> Vector2:
	return hero.logic.stats.decide_travel(state.weight, motion)

func travel(velocity: Vector2) -> void: hero.to.world.skills.pull.apply_velocity(velocity)
func set_platform(platform: CharacterBody2D) -> void: hero.to.jump.feet.floors.entity = platform
func set_box(entity: CharacterBody2D) -> void: hero.to.act.teleport.platform.set_box(entity)
func platforming(velocity: Vector2) -> void: hero.make_velocity(Vector2(velocity.x, 0))
func start_jump(action: String) -> void: hero.to.moves.jump.start(action)
func end_jump() -> void: hero.to.moves.jump.end()

func fight_start() -> void: hero.to.moves.set_fight_start("active")
func fight_skill(p: String) -> void: hero.to.moves.set_fighting("skill_" + p)

func remember_pos() -> void: state.position = hero.position

func extract(sub: Variant) -> int:
	return root.border.extract_at_pos(sub.position, Tile.FLOOR) + sub.height
