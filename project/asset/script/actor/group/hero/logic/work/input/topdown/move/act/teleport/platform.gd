extends Node

@onready var box: Dictionary = { "prev": HUD.ENTITY, "next": HUD.ENTITY }

const LANDED: int = 1.0

var velo: VeloHero 
var target: Rect2
var delta: Vector2:
	get: #target.size if HUD.entity(box.next) else delta) * part
		if Def.entity(box.next): #if box_ride(): # print("theory hero pos: ", hero.position) ; print("theory: ", box.prev.ledge - target.position) #	return box.prev.ledge - target.size
			return target.size
		print("next box: ", box.next.ledge)
		if box_ride():
			print("- old box standing: ", box.prev.ledge)
			return box.next.ledge - box.prev.ledge
		else:
			print("- target pos : ", target.position)
			return box.next.ledge - target.position
		# return box.next.ledge - (box.prev.ledge if box_ride() else target.position)

func box_ride() -> bool: return box.prev != HUD.ENTITY

func is_landed(track: float) -> bool: return track == LANDED

func set_box(next: CharacterBody2D) -> void: box.next = next

func _get_track(track: Vector2, prop: String) -> Vector2:
	if box_ride():
		print("added ", prop, " = ", box.prev.get(prop))
		return track - box.prev.get(prop)
	else:
		print("minus hero pos")
		return track - velo.hero.position

func set_target_stand(track: Vector2) -> void:
	if Def.entity(box.next):
		track = _get_track(track, "offset")
	else:
		track = _get_track(track, "ledge")
	print("NEXT HERO TRAVEL: ", track)
	target = Rect2(velo.hero.position, track)
	print("TARGET IS: ", target)

func sync_hero_pos(proportion: float) -> void:
	#if proportion != 1.0:
	velo.set_position(target.position + delta * proportion)
	print("sync hero pos: ", velo.hero.position)

func reposition(pos: Vector2, platform: CharacterBody2D) -> void:
	print("reposition: ", pos)
	velo.set_position(pos)
	box.prev = platform
	velo.set_platform(platform)

func reparent_hero(prev: Node2D, next: Node2D) -> void:
	prev.remove_child(velo.hero)
	next.add_child(velo.hero)

func _jump_from_platform() -> void:
	reparent_hero(box.prev.view, velo.hero.group)
	reposition(box.prev.ledge + target.size, Defaults.ENTITY)

func _jump_to_platform() -> void:
	if Def.entity(box.prev):
		reparent_hero(velo.hero.group, box.next.view)
	else:
		reparent_hero(box.prev.view, box.next.view)
	reposition(box.next.offset, box.next)

func decide_jump() -> void:
	if !Def.entity(box.next):
		_jump_to_platform()
		return

	if box_ride(): _jump_from_platform()

func teleport(next: Vector2, action: String = "jump") -> void:
	print("START TELEPORTING: ", target.position + target.size)
	set_target_stand(next)
	velo.start_jump(action)

func dash(force: Vector2, action: String = "jump") -> void:
	print("DASH TO GROUND. ")
	teleport(velo.hero.position + force, action)

func move(proportion: float) -> void:
	sync_hero_pos(proportion)
	if is_landed(proportion):
		decide_jump()
		velo.end_jump()

func make(motion: Vector2) -> void:
	velo.make(motion)
	velo.animate(motion)

func travel(motion: Vector2) -> void:
	var velocity: Vector2 = velo.decide(motion)
	velo.make(velocity)
	velo.travel(velocity)

func platforming(motion: Vector2) -> void:
	var velocity: Vector2 = velo.decide(motion)
	velo.platforming(velocity)
	velo.animate(velocity) # motion.y *= axis
