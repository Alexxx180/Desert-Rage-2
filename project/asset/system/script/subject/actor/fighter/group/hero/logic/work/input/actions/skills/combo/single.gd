extends RefCounted

class_name SkillBasis

func _continue_process() -> int: return FAILED

func check_combo(mark: Tick, slots: Array) -> bool:
	return mark.blackboard.get_value(slots[0]).released

func fight_combo(mark: Tick) -> Node:
	var tools: Dictionary = mark.blackboard.get_value("tools")
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
	mark.blackboard.get_value("group").xp.level.multiply.hit()
	return self

func notify(mark: Tick, caption: String) -> void:
	# mark.blackboard.get_value("ui").set_slot_combo(caption)
	var tools: Dictionary = mark.blackboard.get_value("tools")
	var hero: CharacterBody2D = tools.hero
	if tools.combos == null:
		var combo: Label = mark.actor.combos.instantiate()
		combo.tools = tools
		hero.group.lay.execute.layer.add_child(combo)
		tools.combos = combo
	tools.combos.text = caption
	tools.combos.position = hero.position - Vector2(300, 160) # x = 120

func vfx_hint(mark: Tick, scene: PackedScene) -> void:
	var vfx: Sprite2D = scene.instantiate()
	var hero: CharacterBody2D = mark.blackboard.get_value("tools").hero
	hero.group.lay.execute.layer.add_child(vfx)
	vfx.set_direction(hero.position, hero.logic.see.dir)

static func standalone(mark: Tick, slot: int) -> int:
	var combo: Dictionary = mark.blackboard.get_value("combo")
	
	combo.query.push_back(slot)
	if combo.query.size() > combo.max:
		combo.query.pop_front()

	combo.timer.start()
	combo.completed = false
	# Skills.view_actions(combo.query)
	return FAILED
