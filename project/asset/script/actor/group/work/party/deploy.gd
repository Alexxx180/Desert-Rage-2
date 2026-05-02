extends RefCounted

class_name HeroDeploy

signal traverse_camera(node: Node2D, hero: CharacterBody2D)
signal select_hero(hero: CharacterBody2D)

const COUNT: int = 2

var main: int = -1
var next: int = 0
var anchored: bool = false

func get_next() -> int: return (main + 1) % COUNT
func set_next() -> void:
	main = get_next()
	next = get_next()

func switch_hero(party: Array, show: bool, process: bool) -> void:
	party[next].visible = show
	Works.on(party[next], process)

func is_select() -> bool: return _test_input("select", "select")
func is_group() -> bool: return _test_input("deploy", "group")

func _test_input(key: String, mouse: String) -> bool:
	return Input.is_action_pressed(key) or (
		Input.is_action_pressed("mouse_" + mouse) and
		Input.is_action_just_released("mouse_%s_2" % mouse))

func set_anchor() -> void: anchored = !anchored

func select(group: Node2D, leader: CharacterBody2D, follower: CharacterBody2D) -> void: # party.set_heroes() #party.forget_velocity()
	if anchored: group.sync_pos() # V party.show_heroes()
	traverse_camera.emit(leader, follower)
	set_next()
	# select_hero.emit(group.leader)

func group_heroes(group: Node2D) -> void:
	group.sync_pos()
	set_anchor()
	switch_hero(group.party, true, false)

func deploy_group(party: Array) -> void:
	var process: bool = !anchored
	set_anchor()
	switch_hero(party, process, process)

func regroup(group: Node2D) -> void: # not party.same_ground() #if true: pass
	if anchored: group_heroes(group)
	elif group.camera.deploy.is_colliding(group.leader.position, group.follower.position):
		deploy_group(group.party)

func setup_location(group: Node2D) -> void:
	traverse_camera.connect(group.traverse)
	# group.locate(group.position) # camera.deploy.is_near.connect(set_deploy)
	group.ray.position = group.initial
	group.position = Vector2.ZERO

func init(group: Node2D, deployed: bool) -> void:
	setup_location(group)
	select(group, group._rock, group.ray)
	if deployed: regroup(group)
