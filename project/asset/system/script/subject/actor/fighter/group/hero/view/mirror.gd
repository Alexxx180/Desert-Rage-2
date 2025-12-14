extends AnimatedSprite2D

const MIRRORS: int = 2

var _tiles: int = 0

@onready var encounter: Array[Area2D] = [$a, $b]

func _ready() -> void:
	for e in encounter:
		e.body_entered.connect(enter_tile)
		e.body_exited.connect(exit_tile)

func sync(profile: AnimatedSprite2D) -> void:
	profile.animation_changed.connect(func():
		if profile.animation.contains("forward"):
			animation = profile.animation.replace("forward", "backward")
		elif profile.animation.contains("backward"):
			animation = profile.animation.replace("backward", "forward")
		else:
			animation = profile.animation)
	profile.frame_changed.connect(func(): frame = profile.frame)

func _toggle(state: bool) -> void:
	if _tiles == MIRRORS: visible = state

func enter_tile(_b: TileMapLayer) -> void:
	_tiles += 1
	_toggle(true)

func exit_tile(_b: TileMapLayer) -> void:
	_toggle(false)
	_tiles -= 1
