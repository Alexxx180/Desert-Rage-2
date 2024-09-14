extends Node2D

@onready var view: Sprite2D = $view
@onready var stats: Node = $stats
@onready var interaction: Node = $interaction
@onready var geometry: Node = $interaction/handle/placement

func switch_stand(hero: CharacterBody2D, status: bool) -> void:
	if hero.texture != view.texture:
		hero.texture = view.texture
	hero.visible = status
	view.visible = !status

func _ready() -> void:
	interaction.set_control_entity(self)
	stats.set_control_entity(self)

signal update_view(hero: Sprite2D, has_hero: bool)

@export_range(0, 2) var height: int = 1

var _hero: CharacterBody2D

var has_hero: bool = false
var previous: Vector2

func set_floor(F: int):
	if has_hero:
		_hero.detectors.platform.floors.surface.F = F + height

func remember() -> void:
	if has_hero: previous = _hero.position

func rollback() -> void:
	if has_hero: _hero.position = previous

func move(axis: int, velocity: float) -> void:
	if has_hero: _hero.position[axis] += velocity

# func _at_floor(hero: CharacterBody2D) -> bool: return hero.processing.platforming.jump.feet.stable
