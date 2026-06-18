class_name CharacterAnimation extends RefCounted

enum { POWER = 0, INFLUENCE = 1, DOUBLE_COMBO, VITALITY = 2, REACTION = 3, SPEED = 4 } # signal sync_anim(animation: String, frame: int)

var tree: AnimationTree:
	get: return HUD.level.entity[HUD.hero].animation
var sprite: AnimatedSprite2D: # var player: AnimationPlayer
	get: return HUD.level.entity[HUD.hero].profile
var material: ShaderMaterial:
	get: return sprite.material

var directed: int = 0
var frames: int = 0

enum { WALK, RUN, JUMP }

enum { CHAINS, GROUND, DIRECTED = 8 }
enum { BODY, HANG, COMBO }
enum { PULL, AIR }

var state: PackedByteArray = [0, 0]
var sprites: Array[StringName] = [
	&"backward", &"forward", &"backward_left", &"forward_left", &"left", &"backward_right", &"forward_right", &"right",
	&"backward_run", &"forward_run", &"backward_left_run", &"forward_left_run", &"left_run", &"backward_right_run", &"forward_right_run", &"right_run",
	&"backward_jump", &"forward_jump", &"backward_left_jump", &"forward_left_jump", &"left_jump", &"backward_right_jump", &"forward_right_jump", &"right_jump",
	&"backward_kick", &"forward_kick", &"backward_left_kick", &"forward_left_kick", &"left_kick", &"backward_right_kick", &"forward_right_kick", &"right_kick",
	&"backward_punch", &"forward_punch", &"backward_left_punch", &"forward_left_punch", &"left_punch", &"backward_right_punch", &"forward_right_punch", &"right_punch",
	&"backward_push", &"forward_push", &"backward_left_push", &"forward_left_push", &"left_push", &"backward_right_push", &"forward_right_push", &"right_push",
	&"backward_fire", &"forward_fire", &"backward_left_fire", &"forward_left_fire", &"left_fire", &"backward_right_fire", &"forward_right_fire", &"right_fire",
	&"backward_whip", &"forward_whip", &"backward_left_whip", &"forward_left_whip", &"left_whip", &"backward_right_whip", &"forward_right_whip", &"right_whip",
	&"backward_stomp", &"forward_stomp", &"backward_left_stomp", &"forward_left_stomp", &"left_stomp", &"backward_right_stomp", &"forward_right_stomp", &"right_stomp",
	&"backward_chains_move", &"forward_chains_move", &"backward_left_chains_move", &"forward_left_chains_move", &"left_chains_move", &"backward_right_chains_move", &"forward_right_chains_move", &"right_chains_move",
	&"backward_chains_whip", &"forward_chains_whip", &"backward_left_chains_whip", &"forward_left_chains_whip", &"left_chains_whip", &"backward_right_chains_whip", &"forward_right_chains_whip", &"right_chains_whip",
]

func _init() -> void:
	state[BODY] = Bit.to0(state[BODY], RUN)

func animate_fight() -> void:
	pass
	# sprite.animation = 

func animate_frames(type: int) -> void:
	frames = type
	sprite.animation = sprites[get_anim()]

func stop_animation() -> void:
	sprite.stop()
	sprite.animation = sprites[directed]
	sprite.frame = 0

func get_anim() -> int: return directed + DIRECTED * frames # if Bit.of(state[BODY], RUN):

func direct(dir: Vector2i) -> void:
	directed = Def.direct(dir) # Def.MOVE
	

var animations: PackedStringArray = ["idle-1", "walk", "run", "jump", "kick_0", "kick_1",
		"punch_0", "punch_1", "hang_go", "hang_idle", "bash", "stomp"]
var unique: Array[PackedStringArray] = [["fire", "whip"], ["rain", "spark"]] # "hang_whip_dash"
var go: PackedStringArray = ["walk", "run"] ; var hang: PackedStringArray = ["hang", "stand"]

func ask(caption: String) -> String: return "parameters/" + caption + "/current_state"
func request(caption: String) -> String: return "parameters/" + caption + "/transition_request"
func blend(caption: String) -> String: return "parameters/" + caption + "/blend_position"

func animate() -> void:# motion: Vector2
	var anim: int = get_anim()
	sprite.animation = sprites[anim]
	#HUD.level.entity[HUD.hero].animation.stop()
	if not sprite.is_playing():
		sprite.play(sprites[anim])
	return
	"""
	if motion != Vector2.ZERO:
		for pose in hang: tree.set(request(pose), &"move")
		for animation in animations:
			tree.set(blend(animation), motion)
	else:
		#sprite.play()
		#player.play()
		tree.set(&"parameters/stand/transition_request", &"idle")
		#for pose in hang: tree.set(request(pose), &"idle")
	for animation in unique[HUD.hero]: blend(animation)
	if !Bit.of(HUD.state, Def.ACTING): blend("pull_forward")
	"""

func set_walk_speed(mach: int) -> void: tree.set(request("go"), go[(mach - 1) & 1])
func set_move_action(stand: StringName) -> void: tree.set(request("move"), stand)
func set_environment(stand: StringName) -> void: tree.set(request("environment"), stand)
func set_hang(stand: String) -> void: tree.set(request("hang"), stand)

func set_fighting(stand: String) -> void:
	var combo: String = "punch_combo" if stand == "hands" else "kick_combo"
	tree.set(request(combo), (int(tree.get(ask(combo))) + 1) & 1)
	tree.set(request("active"), stand)

func set_fight_start(stand: String) -> void:
	tree.set(request("ground"), stand)
	jump_start(&"move") # probably timeout to set_fight end connect

func set_fight_end() -> void:
	tree.set(request("ground"), &"passive")
	tree.set(request("tools"), &"internal")

func set_damage(multiplier: float = 1) -> void: HUD.level.fight.close_damage(HUD.hero, multiplier)
func set_position(proportion: float) -> void: HUD.level.input.teleport(HUD.hero, proportion)

func fight_tool(stand: String) -> void:
	tree.set(request("tools"), &"external")
	tree.set(request("external"), stand)

func jump_start(action: StringName) -> void:
	set_move_action(action)
	for pose in hang: tree.set(request(pose), &"move")
	HUD.level.entity[HUD.hero].is_monitoring = false

func jump_end() -> void:
	HUD.level.entity[HUD.hero].is_monitoring = true
	set_move_action(&"go")
	tree.set(request("hang_move"), &"go") # print("JUMP FINISHED")

func pull_box(has_boxes: bool) -> void:
	if !Bit.of(HUD.level.state[HUD.hero], Def.JUMP):
		set_move_action(&"pull" if has_boxes else &"go")

func mirror_animation() -> void:
	var animation: String = HUD.level.entity[HUD.hero].profile.animation
	if animation.contains("forward"):
		animation = animation.replace("forward", "backward")
	elif animation.contains("backward"):
		animation = animation.replace("backward", "forward")
	HUD.level.entity[HUD.hero].mirror.animation = animation

func mirror_frame() -> void:
	HUD.level.entity[HUD.hero].mirror.frame = HUD.level.entity[HUD.hero].profile.frame

func set_hanging(next: bool) -> void:
	HUD.level.entity[HUD.hero].view.shadow.position = Vector2(0, 27) if next else Vector2(0, -5)

func set_shadow(next: bool) -> void:
	HUD.level.entity[HUD.hero].view.shadow.visible = next

func get_mirror_sprite(view: CharacterBody2D, path: StringName, mirror: AnimatedSprite2D) -> AnimatedSprite2D:
	if mirror != null: return mirror
	mirror = load(path).instantiate()
	view.set(&"_mirror", mirror)
	view.shadow.add_sibling(mirror)
	view.profile.animation_changed.connect(mirror_animation)
	view.profile.frame_changed.connect(mirror_frame)
	return mirror

func set_aura(next_color: Color, thickness: float) -> void:
	material.set(&"shader_parameter/line_thickness", thickness)
	material.set(&"shader_parameter/line_color", next_color)

func show_ap(value: float) -> void:
	material.set(&"shader_parameter/ability", true)
	material.set(&"shader_parameter/ap", value)

func hide_ap() -> void:
	material.set(&"shader_parameter/ability", false)

func _set_invis(invisible: bool) -> void:
	material.set(&"shader_parameter/invisible", invisible)
	if invisible: set_aura(Color("FFFFFF7F"), 3)
	else: set_aura(Color("FFFFFF00"), 0)
	
func _go_behind_scene(_curtain: TileMapLayer) -> void: _set_invis(true) # MOVE & CONNECT TO LINK
func _go_on_scene(_curtain: TileMapLayer) -> void: _set_invis(false)
