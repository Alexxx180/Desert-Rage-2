extends Node

enum { M = 0, UI = 1 }

var player: bool: set = set_player
var interface: int: set = set_interface
var items: int: set = set_items
var pplayer: IPreset = IPreset.new()
var pinterface: IPreset = IPreset.new()

func set_narrative(op: HFlowContainer, main: VBoxContainer) -> void:
	pplayer.s.p.p("visible").t()
	pplayer.add(op, "help", main.preview.help.hints)
	pplayer.add(op, "narrative", main.preview.chats.list.temp.chat)
	pplayer.add(op, "emotions", main.topic.space.options.chat.margin)
	pplayer.link()

func set_visual(op: HFlowContainer, main: VBoxContainer, work: Node) -> void:
	pinterface.masks(pinterface.p.s.interface()).s.p.p("visible").t()
	pinterface.add(op, "aura", main.status.sticker.hp)
	pinterface.add(op, "resource", main.topic.status.preset.sets.ap)
	pinterface.s.p.p("control").t()
	pinterface.add(op, "damage", main.status.sticker.hp)
	pinterface.add(op, "options", main.status.sticker.hp)
	pinterface.p.p("items").s()
	pinterface.add(op, ["items", "itadaptive", "itstatus", "itfixed"], work) # logic)
	pinterface.p.p("control")
	pinterface.add(op, ["card", "coff", "cadaptive", "cboss", "cfoe"], work) # combo
	pinterface.link()

func set_player(value: bool) -> void: pplayer.switch(value)
func set_interface(value: int) -> void: pinterface.select(value)

func set_items(value: int) -> void:
	pass
