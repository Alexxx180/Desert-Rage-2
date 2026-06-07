extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

var field: int
var state: PackedInt32Array = [0, 0]
var boxes: PackedByteArray = []

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion

func _physics_process(_delta: float) -> void: move_and_slide()

func encounter(_execute: TileMapLayer) -> void: HUD.level.press.encounter(self)
func diverge(_execute: TileMapLayer) -> void: HUD.level.press.diverge(self)
