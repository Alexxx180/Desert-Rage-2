extends Node2D

enum { DEPLOYED, OVERWORLD, CASUAL }

@onready var camera: Camera2D = $camera

@export_group("Deployment")
@export_flags_3d_render var mode: int
@export_flags_3d_physics var enemy: int

var root: LevelRoot
var ray: CharacterBody2D:
	get: return Works.uploads(self, Def.ray, "group/ray", HUD.REF, upload_hero)
var rock: CharacterBody2D:
	get: return Works.uploads(self, Def.rock, "group/rock", HUD.REF, upload_hero)
var music: Node:
	get: return Works.uploads(self, Def.music, "music")

var work: GroupWork

var deploy: HeroDeploy = HeroDeploy.new(position)
var party: Array[CharacterBody2D]:
	get: return [ray, rock]

func controls(_root: LevelRoot) -> void:
	root = root
	deploy.init(self, Bit.of(mode, DEPLOYED))
	if Bit.of(mode, OVERWORLD): camera.set_overworld()

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
