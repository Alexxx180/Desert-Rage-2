class_name CharacterAnimation extends RefCounted

enum { POWER = 0, INFLUENCE = 1, DOUBLE_COMBO, VITALITY = 2, REACTION = 3, SPEED = 4 } # signal sync_anim(animation: String, frame: int)

var directed: int = 0
var frames: int = 0

enum { WALK, RUN, JUMP }
enum { CHAINS, GROUND, DIRECTED = 8 }
enum { BODY, HANG, COMBO }
enum { PULL, AIR }

var state: PackedByteArray = [0, 0]
var sprites: Array[StringName] = [&"b", &"f", &"bl", &"fl", &"l", &"br", &"fr", &"r",
	&"b_run", &"f_run", &"bl_run", &"fl_run", &"l_run", &"br_run", &"fr_run", &"r_run",
	&"b_jump", &"f_jump", &"bl_jump", &"fl_jump", &"l_jump", &"br_jump", &"fr_jump", &"r_jump",
	&"b_kick", &"f_kick", &"bl_kick", &"fl_kick", &"l_kick", &"br_kick", &"fr_kick", &"r_kick",
	&"b_punch", &"f_punch", &"bl_punch", &"fl_punch", &"l_punch", &"br_punch", &"fr_punch", &"r_punch",
	&"b_push", &"f_push", &"bl_push", &"fl_push", &"l_push", &"br_push", &"fr_push", &"r_push",
	&"b_fire", &"f_fire", &"bl_fire", &"fl_fire", &"l_fire", &"br_fire", &"fr_fire", &"r_fire",
	&"b_whip", &"f_whip", &"bl_whip", &"fl_whip", &"l_whip", &"br_whip", &"fr_whip", &"r_whip",
	&"b_stomp", &"f_stomp", &"bl_stomp", &"fl_stomp", &"l_stomp", &"br_stomp", &"fr_stomp", &"r_stomp",
	&"b_c_move", &"f_c_move", &"bl_c_move", &"fl_c_move", &"l_c_move", &"br_c_move", &"fr_c_move", &"r_c_move",
	&"b_c_whip", &"f_c_whip", &"bl_c_whip", &"fl_c_whip", &"l_c_whip", &"br_c_whip", &"fr_c_whip", &"r_c_whip"]
@export var ui_sprites: SpriteFrames

func _init() -> void: state[BODY] = Def.to0(state[BODY], RUN)

func animate_frames(type: int) -> void:
	frames = type
	HUD.level.profile[HUD.hero].sprite.animation = sprites[get_anim()]

func stop_animation() -> void:
	HUD.level.profile[HUD.hero].sprite.stop()
	HUD.level.profile[HUD.hero].sprite.animation = sprites[directed]
	HUD.level.profile[HUD.hero].sprite.frame = 0

func get_anim() -> int: return directed + DIRECTED * frames # if Bit.of(state[BODY], RUN):

func direct(dir: Vector2i) -> void: directed = Def.direct(dir)

var animations: PackedStringArray = ["idle-1", "walk", "run", "jump", "kick_0", "kick_1",
	"punch_0", "punch_1", "hang_go", "hang_idle", "bash", "stomp", "fire", "whip",
	"rain", "spark", "hang", "stand"]

func animate() -> void:# motion: Vector2
	var anim: int = get_anim()
	HUD.level.profile[HUD.hero].sprite.animation = sprites[anim]
	if not HUD.level.profile[HUD.hero].sprite.is_playing():
		HUD.level.profile[HUD.hero].sprite.play(sprites[anim])
	return

func mirror_animation() -> void:
	var animation: String = HUD.level.profile[HUD.hero].animation
	if animation.contains("forward"): animation = animation.replace("forward", "backward")
	elif animation.contains("backward"): animation = animation.replace("backward", "forward")
	HUD.level.mirror[HUD.hero].animation = animation

func mirror_frame() -> void:
	HUD.level.mirror[HUD.hero].frame = HUD.level.profile[HUD.hero].frame

func set_hanging(next: bool) -> void:
	HUD.level.shadow[HUD.hero].position = Vector2(0, 27) if next else Vector2(0, -5)

func set_shadow(next: bool) -> void:
	HUD.level.shadow[HUD.hero].visible = next

func get_mirror_sprite(view: CharacterBody2D, path: StringName, mirror: AnimatedSprite2D) -> AnimatedSprite2D:
	if mirror != null: return mirror
	mirror = load(path).instantiate()
	view.set(&"_mirror", mirror)
	view.shadow.add_sibling(mirror)
	view.profile.animation_changed.connect(mirror_animation)
	view.profile.frame_changed.connect(mirror_frame)
	return mirror

func set_aura(thickness: float, next_color: Color, resource: bool) -> void: # MOVE & CONNECT TO LINK
	if resource:
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/ability", thickness == 0)
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/ap", thickness)
	else: #Color("FFFFFF7F"), 3
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/line_thickness", thickness)
		HUD.level.profile[HUD.hero].material.set(&"shader_parameter/line_color", next_color)
# PARTICLES
enum { PUNCH, APPEAR = 0, KICK, TIME = 1, FIRE, DISAPPEAR = 2, DROP, OFFSET = 10, PATH = 100 }

const timing: PackedFloat32Array = [0.2, 0.4, 0.6]

var texture: Texture
var sprite: Sprite2D

func set_direction(pos: Vector2, direction: Vector2, type: int) -> void:
	sprite = Sprite2D.new()
	match type:
		KICK: texture = preload("res://icon/vfx/kick.png")
		PUNCH: texture = preload("res://icon/vfx/punch.png")
		FIRE: texture = preload("res://icon/vfx/ray/fire.svg")
		DROP: texture = preload("res://icon/vfx/rock/water.svg")
	sprite.position = pos - Vector2(0, 32)
	var offsets: Vector2 = Vector2(OFFSET, OFFSET)
	var angle: float = Def.rotate(direction)
	sprite.rotation = angle
	var delta: Vector2 = Vector2(PATH, PATH) * direction
	if direction.x != 0 and direction.y != 0:
		var axis: int = randi_range(0, 2)
		if axis != 2:
			direction[axis] *= -1
			sprite.position += offsets * direction
		delta *= 0.75
		sprite.modulate = Color.TRANSPARENT
		set_track(sprite.position + delta)
	for i in range(0, 2):
		if direction.x != 0:
			var track: int = randi_range(-1, 1)
			if track != 0:
				direction[i] = track
				sprite.position += offsets * direction * 2
			break # modulate = Color.from_rgba8(127, 127, 127, 127)
	sprite.modulate = Color.TRANSPARENT
	set_track(sprite.position + delta)

func set_track(target: Vector2) -> void:
	var tween: Tween = HUD.create_tween() # .set_parallel(true)
	tween.tween_property(self, ^"modulate", Color.from_rgba8(127, 127, 127, 200), timing[APPEAR])
	tween.parallel().tween_property(self, ^"position", target, timing[TIME])
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, timing[APPEAR])
	tween.tween_callback(sprite.queue_free)

var no: int

func set_interaction(hero: CharacterBody2D, no: int) -> void:
	hero.set_meta(&"no", no) # animation.timeout.connect(stop_animation)
	HUD.level.plate[no] = hero.get_node(^"plate")
	HUD.level.plate[no].body_entered.connect(HUD.level.plate_encounter)
	HUD.level.plate[no].body_exited.connect(HUD.level.plate_disappear)
	HUD.level.lever[no] = hero.get_node(^"lever")
	HUD.level.lever[no].body_entered.connect(HUD.level.lever_encounter)
	HUD.level.lever[no].body_exited.connect(HUD.level.lever_disappear)

func set_monitoring(no: int, value: bool) -> void:
	HUD.level.lever[no].monitoring = value
	HUD.level.plate[no].monitoring = value

func make_velocity(no: int, motion: Vector2) -> void: 
	HUD.level.velocity[no] = motion * HUD.level.weight[no]
# circle # small_circle # after_tile # sided # fireplace
func make_position(no: int, motion: Vector2) -> void:
	HUD.level.entity[no].position = motion
