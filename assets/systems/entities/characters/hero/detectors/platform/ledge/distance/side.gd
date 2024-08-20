extends Node2D

var side: Dictionary:
	get: return { -1: $top, 0: $center, 1: $bottom }
