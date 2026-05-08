extends Node

@onready var jump: LedgeDeployment = LedgeDeployment.new()
@onready var pillar: LevelsPillar = LevelsPillar.new(HUD.NODE)
@onready var box: Dictionary = { "prev": HUD.ENTITY, "next": HUD.ENTITY }

var target: Rect2
var delta: Vector2: get = get_delta # return box.next.ledge - (box.prev.ledge if box_ride() else target.position)

func get_delta() -> Vector2: #target.size if HUD.entity(box.next) else delta) * part #if box_ride(): # print("theory hero pos: ", hero.position) ; print("theory: ", box.prev.ledge - target.position) #	return box.prev.ledge - target.size
	if Def.entity(box.next): return target.size
	return Def.ic("next box: ", box.next.ledge) - (Def.ic("- old box standing: ", box.prev.ledge) if box_ride() else Def.ic("- target pos : ", target.position))

func box_ride() -> bool: return box.prev != HUD.ENTITY

func is_landed(track: float, LANDED: int = 1) -> bool: return track == LANDED

func set_box(next: CharacterBody2D) -> void: box.next = next

func _get_track(track: Vector2, prop: String) -> Vector2:
	return track - (Def.ic("= %s", box.prev.get(Def.ic("added %s", prop))) if box_ride() else Def.ic("minus hero pos %s", jump.velo.hero.position))

func set_target_stand(track: Vector2) -> void:
	track = _get_track(track, "offset" if Def.entity(box.next) else "ledge")
	target = Def.ic("TARGET IS: %s", Rect2(jump.jump.velo.hero.position, Def.ic("NEXT HERO TRAVEL: %s", track)))

func sync_hero_pos(proportion: float) -> void: #if proportion != 1.0:
	jump.jump.velo.set_position(Def.ic("sync hero pos: %s", target.position + delta * proportion))

func reposition(pos: Vector2, platform: CharacterBody2D) -> void:
	jump.jump.velo.set_position(Def.ic("reposition: %s", pos))
	box.prev = platform
	jump.jump.velo.set_platform(platform)

func reparent_hero(prev: Node2D, next: Node2D) -> void:
	prev.remove_child(jump.jump.velo.hero)
	next.add_child(jump.jump.velo.hero)

func _jump_from_platform() -> void:
	reparent_hero(box.prev.view, jump.jump.velo.hero.group)
	reposition(box.prev.ledge + target.size, HUD.ENTITY)

func _jump_to_platform() -> void:
	reparent_hero(jump.jump.velo.hero.group if Def.entity(box.prev) else box.prev.view, box.next.view)
	reposition(box.next.offset, box.next)

func decide_jump() -> void:
	if !Def.entity(box.next): _jump_to_platform()
	elif box_ride(): _jump_from_platform()

func teleport(next: Vector2, action: String = "jump") -> void:
	print("START TELEPORTING: ", target.position + target.size)
	set_target_stand(next)
	jump.jump.velo.start_jump(action)

func dash(force: Vector2, action: String = "jump") -> void:
	teleport(Def.ic("DASH TO GROUND. %s", jump.jump.velo.hero.position + force), action)

func move(proportion: float) -> void:
	sync_hero_pos(proportion)
	if is_landed(proportion):
		decide_jump()
		jump.jump.velo.end_jump()

func make(motion: Vector2) -> void:
	jump.jump.velo.make(motion)
	jump.jump.velo.animate(motion)

func travel(motion: Vector2) -> void:
	var velocity: Vector2 = jump.jump.velo.decide(motion)
	jump.jump.velo.make(velocity)
	jump.jump.velo.travel(velocity)

func platforming(motion: Vector2) -> void:
	var velocity: Vector2 = jump.jump.velo.decide(motion)
	jump.jump.velo.platforming(velocity)
	jump.jump.velo.animate(velocity) # motion.y *= axis
