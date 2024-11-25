extends Node2D

signal sync_view(hero: Node2D)

@export var is_hero: bool = false

@onready var profile: AnimatedSprite2D = $profile
@onready var animation: AnimationTree = $animation

func _ready() -> void: visible = is_hero

func sync_image(hero: Node2D) -> void:
	animation.sync(hero.animation)
	#profile.texture = hero.profile.texture

func update_image() -> void:
	sync_view.emit(self)
 
func enable_sync(_seat: Node, hero: CharacterBody2D) -> void:
	visible = true
	hero.view.sync_view.connect(sync_image)
	hero.view.update_image()

	#TODO: Comment or delete those lines:
	# actual only for builds without character separation
	profile.modulate = hero.modulate


func disable_sync(_seat: Node, hero: CharacterBody2D) -> void:
	visible = false
	hero.view.sync_view.disconnect(sync_image)
