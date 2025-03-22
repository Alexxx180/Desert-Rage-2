extends Node2D

signal sync_view(hero: Node2D)

enum { BEHIND = 60, ONSCENE = 255 }

@export var is_hero: bool = false

@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation

func _ready() -> void: visible = is_hero

func _mod(transparency: int) -> void: modulate.a8 = transparency
func _go_behind_scene(_curtain: TileMapLayer) -> void: _mod(BEHIND)
func _go_on_scene(_curtain: TileMapLayer) -> void: _mod(ONSCENE)

func sync_image(hero: Node2D) -> void:
	animation.sync(hero.animation)

func update_image() -> void:
	sync_view.emit(self)
 
func enable_sync(_seat: Node, hero: CharacterBody2D) -> void:
	visible = true
	hero.logic.processors.input.moving.connect(animation.move)
	hero.view.sync_view.connect(sync_image)
	hero.view.update_image()
	#TODO: Comment: actual only for builds without character separation
	#profile.modulate = hero.modulate

func disable_sync(_seat: Node, hero: CharacterBody2D) -> void:
	visible = false
	hero.view.sync_view.disconnect(sync_image)
	hero.logic.processors.input.moving.disconnect(animation.move)
