class_name CharacterAnimation extends RefCounted

enum { POWER = 0, INFLUENCE = 1, DOUBLE_COMBO, VITALITY = 2, REACTION = 3, SPEED = 4 } # signal sync_anim(animation: String, frame: int)

var tree: AnimationTree:
	get: return HUD.level.entity[HUD.hero].animation

var animations: PackedStringArray = ["idle-1", "walk", "run", "jump", "kick_0", "kick_1",
		"punch_0", "punch_1", "hang_go", "hang_idle", "bash", "stomp"]
var unique: Array[PackedStringArray] = [["whip_dash", "fire", "whip", "hang_whip_dash"], ["rain", "spark"]]
var go: PackedStringArray = ["walk", "run"] ; var hang: PackedStringArray = ["hang", "stand"]

func ask(caption: String) -> String: return "parameters/" + caption + "/current_state"
func request(caption: String) -> String: return "parameters/" + caption + "/transition_request"
func blend(caption: String) -> String: return "parameters/" + caption + "/blend_position"

func direct(motion: Vector2) -> void:
	if motion != Vector2.ZERO:
		for pose in hang: tree.set(request(pose), &"move")
		for animation in animations: tree.set(blend(animation), motion)
	else:
		for pose in hang: tree.set(request(pose), &"idle")
	for animation in unique[HUD.hero]: blend(animation)
	if !Bit.of(HUD.state, Def.ACTING): blend("pull_forward")

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
	var animation: String = HUD.level.entity[HUD.hero].view.profile.animation
	if animation.contains("forward"):
		animation = animation.replace("forward", "backward")
	elif animation.contains("backward"):
		animation = animation.replace("backward", "forward")
	HUD.level.entity[HUD.hero].view.mirror.animation = animation

func mirror_frame() -> void:
	HUD.level.entity[HUD.hero].view.mirror.frame = HUD.level.entity[HUD.hero].view.profile.frame

func set_hanging(state: bool) -> void:
	HUD.level.entity[HUD.hero].view.shadow.position = Vector2(0, 27) if state else Vector2(0, -5)

func set_shadow(state: bool) -> void:
	HUD.level.entity[HUD.hero].view.shadow.visible = state
