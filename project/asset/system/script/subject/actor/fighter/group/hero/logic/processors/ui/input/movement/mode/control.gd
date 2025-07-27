extends Node

enum { JUMP = 200000, GRAVITY = 700000 } # JUMP = -75000, GRAVITY = 375000 / 150 - 750

var mode: Node
var height: float = 0

func jump() -> void: select_mode(true, -JUMP)
func land() -> void: select_mode(false, 0)

func select_mode(jumped: bool, target: float) -> void:
	height = target
	mode.hero.movement = gravity if jumped else floating # hero.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED / CharacterBody2D.MOTION_MODE_FLOATING

func floating(_delta: float) -> void:
	mode.hero.move_and_slide()

func gravity(delta: float) -> void: # if score > HEIGHT * CELL:	hero.velocity.y -= delta * TRY; score += delta * TRY # else:
	mode.hero.velocity.y += delta * height
	if height < GRAVITY:
		height += delta * (GRAVITY + JUMP)
	print("HEIGHT: ", height)
	floating(delta)
