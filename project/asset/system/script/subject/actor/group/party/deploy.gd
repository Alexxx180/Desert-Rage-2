extends RefCounted

class_name HeroDeploy

signal traverse_camera(node: Node2D, hero: CharacterBody2D)

var party: HeroParty = HeroParty.new()
var _group: Array[bool] = [false, false]

func set_deploy(able: bool) -> void: _group[1] = able

func set_anchor() -> void: _group[0] = !_group[0]

func select(hero: Node2D = party.leader) -> void:
	party.set_heroes()
	if _group[0]:
		party.sync_pos()
		party.show_heroes()
	traverse_camera.emit(hero, party.follower)
	party.set_next()

func group_heroes() -> void:
	party.sync_pos()
	set_anchor()
	party.switch_hero(true, false)

func deploy_group() -> void:
	set_anchor()
	party.regroup_hero(!_group[0])

func regroup() -> void:
	if not party.same_ground(): pass
	elif _group[0]: group_heroes()
	elif _group[1]: deploy_group()

func setup_camera(camera: Camera2D) -> void:
	traverse_camera.connect(camera.traverse)
	camera.deploy.is_near.connect(set_deploy)

func setup_location(group: Node2D) -> void:
	setup_camera(group.camera)
	party.locate(group.position)
	group.position = Vector2.ZERO

func init(group: Node2D, heroes: Array[CharacterBody2D], deployed: bool) -> void:
	party.heroes = heroes
	setup_location(group)
	select(group)
	set_deploy(deployed)
	if deployed: regroup()
