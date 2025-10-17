extends RefCounted

class_name HeroDeploy

signal traverse_camera(node: Node2D, hero: CharacterBody2D)
signal select_hero(hero: CharacterBody2D)

var party: HeroParty = HeroParty.new()
var _deploy: Node2D
var anchored: bool = false

func set_anchor() -> void: anchored = !anchored

func select(hero: Node2D = party.leader) -> void:
	party.set_heroes()
	#party.forget_velocity()
	if anchored:
		party.sync_pos()
		party.show_heroes()
	traverse_camera.emit(hero, party.follower)
	party.set_next()
	select_hero.emit(party.leader)

func group_heroes() -> void:
	party.sync_pos()
	set_anchor()
	party.switch_hero(true, false)

func deploy_group() -> void:
	set_anchor()
	party.regroup_hero(!anchored)

func regroup() -> void: # not party.same_ground() #if true: pass
	if anchored: group_heroes()
	elif _deploy.is_colliding(
		party.leader.position, party.follower.position):
		deploy_group()

func setup_camera(camera: Camera2D) -> void:
	traverse_camera.connect(camera.traverse)
	_deploy = camera.deploy
	#camera.deploy.is_near.connect(set_deploy)

func setup_location(group: Node2D) -> void:
	setup_camera(group.camera)
	party.locate(group.position)
	group.position = Vector2.ZERO

func init(group: Node2D, heroes: Array[CharacterBody2D], deployed: bool) -> void:
	party.heroes = heroes
	setup_location(group)
	select(group)
	if deployed: regroup()
