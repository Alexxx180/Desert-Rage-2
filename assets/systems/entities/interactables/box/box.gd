extends Node2D

@onready var view: Sprite2D = $view
@onready var stats: Node = $stats
@onready var interaction: Node = $interaction
@onready var geometry: Node = $interaction/handle/placement

func switch_stand(hero: CharacterBody2D, status: bool) -> void:
	hero.stand.visible = status
	view.visible = !status

func set_stand(hero: CharacterBody2D) -> void:
	hero.stand.texture = view.texture

func _ready() -> void:
	interaction.set_control_entity(self)
	stats.set_control_entity(self)
