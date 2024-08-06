extends CharacterBody2D

@export var control: bool = false

@onready var size: Node2D = $base/size
@onready var interaction: StaticBody2D = $detectors/interaction
@onready var surface: Node = $detectors/platform/floor/surface
@onready var processing = $processing
