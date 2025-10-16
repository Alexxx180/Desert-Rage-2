extends Node2D

@export var stats: EntityStats

@onready var hero: CharacterBody2D = get_parent()
@onready var see: Node2D = $see
@onready var work: Node = $work
@onready var link: Node = $link

func _ready() -> void: stats.update_stats()

func _physics_process(delta: float) -> void:
	hero.move_and_slide()
