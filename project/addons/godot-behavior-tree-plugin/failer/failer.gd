@tool
extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

""" Decorator node. Always returns FAILED if not running """

func tick(_mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		if child._execute(tick) == ERR_BUSY:
			return ERR_BUSY
	return FAILED
