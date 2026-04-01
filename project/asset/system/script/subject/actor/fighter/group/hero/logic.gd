extends Node2D

var stats: EntityStats

@onready var hero: CharacterBody2D = get_parent()
@onready var see: Node2D = $see
@onready var work: Node = $work
@onready var link: Node = $link

func update_stats() -> void:
	stats = load("res://asset/resource/media/data/stats/hero/%s.tres" % get_parent().name)#.instantiate()
	stats.update_stats()

func _physics_process(delta: float) -> void:
	hero.move_and_slide()
