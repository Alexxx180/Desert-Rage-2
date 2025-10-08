extends Node2D

@onready var ground: Area2D = $ground
# @onready var platform: Area2D = $platform
@onready var platform: ShapeCast2D = $platform
@onready var slide: ShapeCast2D = $slide
@onready var spring: ShapeCast2D = $spring
