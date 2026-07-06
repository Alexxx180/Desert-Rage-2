extends Node

var s: Node

func sect_logic(op: HFlowContainer, logic: Node) -> void:
	s.p.n(".")
	s.sets(op, logic, [["screen", "SWND", "SFSC"]])
	#["genre", "SRPG", "SATN"]
	s.select(op, ["interface", "imin", "iadaptive", "ifull", "ifixed"], logic, s.p.p("interface").d)

func controls(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	s.select(op, ["language", "lenglish", "lrussian"], work.experience.interface.logic, s.p.p("interface").s().d)
	sect_logic(op, work.experience.interface.logic)
	sections(op, main, work)
	s.tap(op, "damage", main.status.sticker.hp, s.p.p("control").t().d)

func controls_hero(group: Node2D, main: VBoxContainer, combo: Node) -> void:
	for hero in group.deploy.party.heroes:
		hero.logic.work.input.topdown.actions.combo = combo
	# main.topic.space.title.enemies.enemy.caption.combo = combo # TODO FIXME enemy

func sections(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	var combo: Node = work.experience.game.combo
	controls_hero(work.get_node("../../../group"), main, combo)
	s.select(op, ["combo", "ctoggle", "ccount"], combo, s.p.p("control").n("status").s(true).d)
