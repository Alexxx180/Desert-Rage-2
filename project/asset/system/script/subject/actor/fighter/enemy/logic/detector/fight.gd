extends Node2D

@onready var hitbox: StaticBody2D = $hitbox
@onready var damagebox: Area2D = $damagebox
@onready var aim: Button = $aim

func reveal_aim() -> void: aim.show()
func hide_aim() -> void: aim.hide()
