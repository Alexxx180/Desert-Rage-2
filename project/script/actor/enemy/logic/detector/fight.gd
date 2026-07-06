extends Node2D

signal assign(enemy: CharacterBody2D)

@onready var damagebox: Area2D = $damagebox
@onready var aim: Button = $aim
@onready var enemy: CharacterBody2D = get_node("../../..")

func set_assign() -> void:
	assign.emit(enemy)

func _ready() -> void:
	aim.pressed.connect(set_assign)

func reveal_aim() -> void: aim.show()
func hide_aim() -> void: aim.hide()
