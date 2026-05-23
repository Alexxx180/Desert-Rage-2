class_name InputExample extends RefCounted

static func b(fields: PackedByteArray) -> int: return Bit.take8(fields)
func _moves() -> Vector2: return Input.get_vector(action[LEFT], action[RIGHT], action[UP], action[DOWN])
func _press(no: int) -> bool: return Input.is_action_just_pressed(action[no])
func _hold(no: int) -> bool: return Input.is_action_pressed(action[no])
func _power(no: int) -> float: return Input.get_action_strength(action[no])
func act(no: int) -> bool: return Bit.from(combo, DOUBLE)

enum { LEFT, RIGHT, UP, DOWN, ACT1, ACT2, ACT3, ACT4, OPT_LEFT, OPT_RIGHT, OPT_UP,
	OPT_DOWN, FIRE, AIM, MENU }
enum { A, B, X, Y, G }
enum { DOUBLE = b([A, A]), LUNGE = b([B, A, A]), DEAD_GRIP = b([A, Y, A]),
	LOW_KICK = b([A, B, A]), BACKSTAB = b([B, B, A]), FIRE_KICK = b([B, X, B]),
	SPIT_KICK = b([B, A, B]), BACK_SPIT = b([B, A, A, B]), POACHING = b([A, Y, A, Y]),
	GREEK_FIRE, STRAY_BULLET, AIR_FIGHT, AID, FIRE_DANCE, BREAKFLY, SHRAPNEL,
	WET_CLEANING, DEFIBRILLATOR, HORIZONTAL,
	ROUND_ATTACK, WASHING_OUT, TRANSFUSION, AIR_STRIKE, SHOCK, ELECTROCUT,
	THUNDER
}
var timer: Timer
var menu_open: bool
# var hero: int enum { RAY, ROCK } enum { TOOL, FIGHT, DANCE }
var action: PackedStringArray = ["left", "right", "up", "down", "action", "run",
	"skill_one", "skill_two", "fire", "targeting", "menu", "alt_left",
	"alt_right", "alt_up", "alt_down"]
var combo: int

func input(_event: InputEvent) -> void:
	if menu_open:
		menu_interaction()
	else:
		action_input()

func action_input() -> void:
	if _press(ACT1): punch()
	if _press(ACT2): kick()
	if _press(ACT3): skill_a()
	if _press(ACT4): skill_b()
	if _hold(AIM) and _press(FIRE): use_item()
	if _hold(MENU): open_menu()

func punch() -> void:
	combo = Bit.add(combo, P)
	if act(DOUBLE):
		if act(LUNGE):
			pass
	if act(DEAD_GRIP):
		pass
	if act(LOW_KICK):
		pass
	if act(BACKSTAB):
		pass
	
	hands("Двоечка")
	timer.start()

func kick() -> void:
	if act(SPIT_KICK):
		pass
	if act(BACK_SPIT):
		pass
	if act(FIRE_KICK):
		pass

func skill_a() -> void:
	pass

func skill_b() -> void:
	if act(POACHING):
		pass

func use_item() -> void:
	pass

func open_menu() -> void:
	pass

func menu_interaction() -> void:
	pass

func _continue_process() -> int: return FAILED

func check_combo(mark: Tick, slots: Array) -> bool:
	return mark.blackboard.g(slots[0]).released

func fight_combo(mark: Tick) -> Node:
	var tools: Dictionary = mark.blackboard.g("tools")
	var combo: Node = tools.hero.view.animation.moves.combo
	combo.start_fight("active")
	return combo

func tick(mark: Tick, act: BehaviorAction) -> int:
	if check_combo(mark, act.get_metadata()):
		# print("GOT A COMBO!")
		act.take_effect(mark)
		return _continue_process()
	return FAILED

func x1(mark: Tick) -> SkillBasis:
	mark.blackboard.g("group").xp.level.multiply.hit()
	return self

func notify(mark: Tick, caption: String) -> void:
	# mark.blackboard.get_value("ui").set_slot_combo(caption)
	var tools: Dictionary = mark.blackboard.g("tools")
	var hero: CharacterBody2D = tools.hero
	if tools.combos == null:
		var size: int = mark.blackboard.g("combo").query.size()
		# if not mark.actor.combo.prefers(size): return TODO FIXME uncomment after settings fully implemented
		var combo: Label = mark.actor.combos.instantiate()
		combo.tools = tools
		hero.group.lay.execute.layer.add_child(combo)
		tools.combos = combo
	tools.combos.text = caption
	tools.combos.position = hero.position - Vector2(300, 160) # x = 120












func _body(text: String, no: int, type: String = "hands") -> void:
	var mark: Tick
	basis.fight_combo(mark).fight_body(type).x(mark, no).notify(mark, text)

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p]

func take_effect(mark: Tick) -> void:
	HUD.xp.level.multiply.by_slots(slots) # mark.blackboard.g("group")
	
	basis.x(mark, Skills.TRIPLE).vfx_hint(mark, mark.actor.kick)
	basis.notify(mark, "Выпад")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
