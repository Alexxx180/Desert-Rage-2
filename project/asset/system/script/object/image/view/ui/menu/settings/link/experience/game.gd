extends Node

var s: Node

func controls(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	s.tap(op, "genre", work.experience.game.logic, s.p.p("genre").n().t("SRPG", "SATN").d)
	#s.tap(op, "difficulty", work.experience.game.combo, s.p.p("control").t().d)
	s.tap(op, "quotes", main.preview.chats.list.temp.quotes, s.p.d)
	s.select(op, ["difficulty", "dcasual", "dsuitable"], work.experience.game.combo, s.p.p("control").s().d)
	#sections(op, main, work)
