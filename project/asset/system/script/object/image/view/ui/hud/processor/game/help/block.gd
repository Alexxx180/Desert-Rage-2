extends Node

@onready var _chat: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/preview/log/chat.tscn")
# @onready var _logs: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/preview/log/item.tscn")

var hud: VBoxContainer
var panel: VBoxContainer
var emotion: Array = []

func chat(who: String, key: String):
	var statement: Label = _chat.instantiate()
	statement.say(who, key)
	return statement

func chats(who: String, result: Array, key: String, count: int) -> void:
	for i in range(count): result.append(chat(who, key))

func insert_chat(h: Label, p: Label) -> void:
	hud.chat.insert(h)
	panel.insert(p) # .chat

func add_chat(nodes: Array) -> void:
	hud.temp.chat.append(nodes[0])
	hud.chat.append(nodes[1]) # add_child
	panel.append(nodes[2]) # chat

func hide_emotion() -> void: for e in emotion: e.hide_animation()
func set_emotion(id: Dictionary) -> void:
# id.alias.to_lower()
	for e in emotion: e.set_animation('r' + "_" + id.face)
