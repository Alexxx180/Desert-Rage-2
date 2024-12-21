extends Node2D

@export var stats: EntityStats

@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors
@onready var relations: Node = $relations
