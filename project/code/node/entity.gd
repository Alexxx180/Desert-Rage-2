class_name EntityStats extends Resource

const STEP: int = 20#00

@export_group("Survival")
@export_range(1, 500, 1, "HP") var health: float = 100
@export_range(1, 500, 1, "AP") var aura: float = 20

@export_group("Fight stats")
@export_range(1, 255, 1, "Damage") var power: float = 5
@export_range(1, 255, 1, "Skills") var influence: float = 5
@export_range(1, 255, 1, "Defence") var vitality: float = 5
@export_range(1, 255, 1, "No fight") var reaction: float = 5

@export_group("World metrics")
@export_range(10, 64, 1, "Box force") var push: int = 2
@export_range(10, 255, 1, "Overall speed") var run: int = 33 # 20

var _mach: int = 1
var speed: float = 0
var force: float = 0# var motion: Vector2

func update_stats():
	speed = _mach * STEP * run
	force = _mach * STEP * push

func accelerate(mach: int) -> void:
	_mach = mach
	update_stats()

func decide_travel(weight: int, move: Vector2) -> Vector2:
	# print("VELOCITY: ", move * force, " - W: ", weight) # motion =
	return move * speed if weight == 0 else move * force / (weight + 1)#  / STEP #return motion



extends AdvancedCharacterAnimation

@onready var moves: Node = $moves
@onready var effect: Node = $effect
@onready var syncer: Node = $syncer

func _ready() -> void:
	direct()
	effect.moves = moves
	syncer.moves = moves

func unique_animations() -> Array[String]:
	return ["rain", "spark"]

func direct() -> void:
	super.direct()
	for animation in unique_animations(): blend(animation)
	if not Input.is_action_pressed("action"): blend("pull_forward")

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	# print("ANIMATE MOTION: ", motion)
	if turned: moves.set_base_stance("move")
	else: moves.set_base_stance("idle")
	return turned


extends Node

var moves: Node

func sync(tree: AdvancedCharacterAnimation) -> void:
	moves.hero = tree.moves.hero
	"""
	moves.tree.direction = tree.direction
	moves.tree.request("go", tree.ask("go")) # set_speed(tree.scale)
	 # tree.pose
#	if moves.hero.logic.work.input.topdown.levels.jump.jumped:
		# moves.set_jump_end()
	# moves.set_base_stance("idle")
	moves.set_move_action(tree.ask("move")) # maze
	moves.tree.direct()
	# """



extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic
@export var caption: String = "eye-seeker"

var spawn_pos: int = 0

func _ready() -> void: logic.relation.controls(self)

func burn(damage: int) -> void: logic.processor.health.burn(damage)

func hit(damage: int) -> void:
	logic.processor.health.hit(damage)
	view.hit(damage)

func teleport(pos: Vector2) -> void: logic.processor.path.teleport(pos)




extends Node

@onready var track: Node = $track
@onready var enemy: CharacterBody2D = get_node("../../..")

var target: Rect2

func teleport(next: Vector2) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.position = next

func dash(force: Vector2) -> void:
	teleport(enemy.position + force)

func reset_velocity(motion: Vector2) -> void:
	enemy.velocity = motion

func forget_velocity() -> void:
	reset_velocity(Vector2.ZERO)
	enemy.view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion *= track.speed
	reset_velocity(motion)

func _physics_process(_delta: float) -> void:
	var motion: Vector2 = track.motion
	enemy.view.animation.move(motion)
	reset_velocity(motion)
	enemy.move_and_slide()




extends Node

@export var speed: int = 200
@export var vertical: bool = false
@onready var hit: Timer = $hit

var paralyzed: bool = false
var direction: float = -1.0
var _motion_path: Callable
var motion: Vector2
var obstacles_counter: int = 0

func update_movement():
	motion = _motion_path.call() # print("MOTION: ", motion)

func _ready() -> void: ignite_motion()

func ignite_motion() -> void:
	_motion_path = _vertical_motion if vertical else _horizontal_motion
	update_movement()

func freeze_motion() -> void:
	_motion_path = _no_motion
	update_movement()

func _no_motion() -> Vector2: return Vector2.ZERO
func _horizontal_motion() -> Vector2: return Vector2(0, direction * speed)
func _vertical_motion() -> Vector2: return Vector2(direction * speed, 0)

func temporary_freeze() -> void:
	if not paralyzed:
		freeze_motion()
		hit.start()

func paralyze(_body) -> void:
	paralyzed = true
	freeze_motion()

func stop_paralyze(_body) -> void:
	ignite_motion()
	paralyzed = false

func enter_obstacle(_body) -> void:
	obstacles_counter += 1
	if obstacles_counter == 1:
		avoid_obstale()

func exit_obstacle(_body) -> void:
	obstacles_counter -= 1

func avoid_obstale() -> void:
	direction *= -1
	update_movement()




extends AdvancedCharacterAnimation

@onready var dead: Node = $dead
@onready var timer: Timer = $timer

func _ready() -> void: direct()

func direct_animations() -> Array[String]:
	return ["rolling"]

func move(motion: Vector2) -> bool:
	var turned: bool = super.move(motion)
	if turned: request("enemy", "active")
	#else: request("enemy", "passive")
	return turned

func dead_animation() -> void:
	dead.start()
	interrogate()

func interrogate() -> void:
	timer.start()

func interrogation_end() -> void:
	dead.health.aura.stop_blinking()
	dead.health.aura.diffusion()
	request("enemy", "dead")

func dead_animation_end() -> void:
	dead.effect()
	request("enemy", "alive")

func live_animation_end() -> void:
	dead.path.ignite_motion()
	dead.damage.monitoring = true
	request("enemy", "active")





extends Node2D

@export var outline: Shader
@onready var timer: Timer = $timer
@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation
@onready var sand: GPUParticles2D = $particle

var hit_direction: int = 1

func _ready() -> void:
	profile.material = ShaderMaterial.new()
	profile.material.set("shader", outline)

func hit(_damage: int) -> void:
	skew = deg_to_rad(randf_range(4.0, 18.0) * hit_direction)
	hit_direction *= -1
	sand.process_material.direction.x = hit_direction
	sand.appear()
	timer.start()
	# create_tween().tween_property(self, "skew", deg_to_rad(0), 1.5)

func normalize_skew() -> void: skew = 0
