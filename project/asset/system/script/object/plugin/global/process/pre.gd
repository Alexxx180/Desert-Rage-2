class_name PreloadBus extends RefCounted

var enemy: Adversaries = Adversaries.new()

var rain: PackedScene = preload("res://pre/particle/rain.tscn")
var sand: PackedScene = preload("res://pre/particle/sand.tscn")
var fire: PackedScene = preload("res://pre/particle/fire.tscn")
var kick: PackedScene = preload("res://pre/particle/fight/kick.tscn")
var punch: PackedScene = preload("res://pre/particle/fight/punch.tscn")

var dialog: PackedScene = preload("res://pre/ui/dialog.tscn")
var combo: PackedScene = preload("res://pre/ui/combo.tscn")
var chat: PackedScene = preload("res://pre/ui/log/chat.tscn")
var item: PackedScene = preload("res://pre/ui/log/item.tscn")
var levels: PackedScene = preload("res://pre/ui/log/levels.tscn")
var multiply: PackedScene = preload("res://pre/multiply.tscn")

var ailments: PackedScene = preload("res://pre/ui/status/ailments.tscn")
var stats: PackedScene = preload("res://pre/ui/status/stats.tscn")
var bag: PackedScene = preload("res://pre/ui/status/items.tscn")
var chats: PackedScene = preload("res://pre/ui/menu/chat.tscn")
var priorities: PackedScene = preload("res://pre/ui/menu/priorities.tscn")

var grabber: GradientTexture2D = preload("res://pre/grabber.tres")
var root: Script = preload("res://pre/level.gd")
var _ost: SoundtrackUI = null
var ost: SoundtrackUI:
	get: return Works.lazy(self, SoundtrackUI.new() if _ost == null else _ost, "ost")
