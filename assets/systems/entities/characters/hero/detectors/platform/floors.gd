extends Area2D

@onready var ground: Node = $ground
@onready var surface: Node = $surface
@onready var geometry: CollisionShape2D = $geometry

func _ready(): surface.ground = ground

func set_control_entity(hero: CharacterBody2D):
	ground.set_control_entity(hero, hero.processing.input, geometry)
	surface.set_control_entity(hero)
