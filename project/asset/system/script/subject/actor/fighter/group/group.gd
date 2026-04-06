extends Node2D

@onready var camera: Camera2D = $camera
@onready var xp: Node = $xp
@onready var initial: Vector2 = position

@export_group("Deployment")
@export var is_overworld: bool = false
@export var deployed: bool = true
@export var casual_mode: bool = false
@export_group("Enemies")
@export_flags_3d_physics var monsters: int
@export_flags_3d_navigation var bosses: int

var root: LevelRoot
var _ray: CharacterBody2D = null
var ray: CharacterBody2D:
	get: return upload_hero(_ray, "ray")

var _rock: CharacterBody2D = null
var rock: CharacterBody2D:
	get: return upload_hero(_rock, "rock")

var _music: Node = null
var music: Node:
	get: return Works.upload(self, _music, "res://asset/system/scene/subject/actor/group/music.tscn", "music")

var navigation: Array
var deploy: HeroDeploy = HeroDeploy.new()
var party: Array[CharacterBody2D]:
	get: return [ray, rock]
var leader: CharacterBody2D: get = get_leader
var follower: CharacterBody2D: get = get_follower

func controls(_root: LevelRoot) -> void:
	root = root
	deploy.init(self, deployed)
	if is_overworld: camera.set_overworld()

func upload_hero(ref: CharacterBody2D, caption: String) -> CharacterBody2D:
	if ref == null:
		ref = load("res://asset/system/scene/subject/actor/group/hero/%s/%s.tscn" % [caption, caption]).instantiate()
		ref.name = caption
		ref.update_stats()
		set("_" + caption, ref)
		add_child(ref)
		ref.controls()
	return ref

func get_leader() -> CharacterBody2D: return party[deploy.main]
func get_follower() -> CharacterBody2D: return party[deploy.next]
func sync_pos() -> void: follower.position = leader.position
func locate(next: Vector2) -> void: for hero in party: hero.position = next
func forget_velocity() -> void:
	leader.logic.work.input.topdown.move.act.velocity.forget()

func traverse(node: Node, hero: CharacterBody2D):
	if node != null:
		node.remove_child(camera)
	else:
		remove_child(camera)
	hero.add_child(camera)

func _ready() -> void: get_parent().set_script(Defaults.pre.root)

func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		var last: bool = n.hud.logic.is_opened_last
		result = result and (not last)
	return not result

func _set_input(state: bool) -> void:
	for hero in party: hero.logic.work.input.suspended = state

func resume_input() -> void: if not is_hud_opened(): _set_input(false)
func suspend_input() -> void: _set_input(true)

func _input(_event: InputEvent) -> void:
	if deploy.is_select(): deploy.select(self, leader, follower)
	elif deploy.is_group(): deploy.regroup(self)
