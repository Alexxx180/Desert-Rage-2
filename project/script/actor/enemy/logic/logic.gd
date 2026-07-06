extends Node2D

@export var stats: EntityStats

@onready var detector: Node2D = $detector
@onready var processor: Node = $processor
@onready var relation: Node = $relation
