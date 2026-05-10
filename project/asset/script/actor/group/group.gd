extends Node2D

@onready var camera: Camera2D = $camera

@export_group("Deployment")
@export var is_overworld: bool = false
@export var deployed: bool = true
@export var casual_mode: bool = false
@export_flags_3d_physics var enemy: int

var root: LevelRoot
var ray: CharacterBody2D:
	get: return Works.uploads(self, LoadBus.ray, "group/ray", upload_hero)
var rock: CharacterBody2D:
	get: return Works.uploads(self, LoadBus.rock, "group/rock", upload_hero)
var music: Node:
	get: return Works.uploads(self, LoadBus.music, "music")

var work: GroupWork

var deploy: HeroDeploy = HeroDeploy.new(position)
var party: Array[CharacterBody2D]:
	get: return [ray, rock]

func controls(_root: LevelRoot) -> void:
	root = root
	deploy.init(self, deployed)
	if is_overworld: camera.set_overworld()

func upload_hero(ref: CharacterBody2D) -> void:
	ref.update_stats()
	ref.controls()

func leader() -> CharacterBody2D: return party[deploy.main]
func follower() -> CharacterBody2D: return party[deploy.next]
func sync_pos() -> void: follower().position = leader().position
func locate(next: Vector2) -> void: for hero in party: hero.position = next
func forget_velocity() -> void:
	leader().logic.work.input.topdown.move.act.velocity.forget()

func traverse(node: Node, hero: CharacterBody2D):
	if node != null:
		node.remove_child(camera)
	else:
		remove_child(camera)
	hero.add_child(camera)

func _ready() -> void: get_parent().set_script(PreloadBus.root)

func _input(_event: InputEvent) -> void:
	if deploy.is_select(): deploy.select(self, leader(), follower())
	elif deploy.is_group(): deploy.regroup(self)
