class_name LevelRoot extends Node2D

@onready var group: Camera2D = $group
@onready var border: TileDecorator = $border ; var execute: TileDecorator

var entity: Array[CharacterBody2D] = [null, null]
var tile: PackedInt32Array = [0, 0, 0, 0]

var cluster: PackedInt32Array = []
var access: PackedInt32Array = []
var sizes: PackedByteArray = [0, 0, 0, 0]
var buttons: Dictionary[int, int] = {}
var hint: PackedInt32Array = []

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()
