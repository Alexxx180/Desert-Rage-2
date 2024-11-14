extends Node

@onready var floors: Node = $floors

var _contact: Node2D

func _debug_contact(contact: Vector2) -> void:
	_contact.position = contact

func set_control(surface: Node, hero: CharacterBody2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	var tracking: Node = surface.tracking

	tracking.set_contacts(hero.geometry.shape.size)
	tracking.entity = hero
	
	"""
	_contact = hero.get_node("../../contact")
	surface.tilemap.margin.debug_contact.connect(_debug_contact)
	#"""

	floors.set_control(surface.floors, jump.overview)
