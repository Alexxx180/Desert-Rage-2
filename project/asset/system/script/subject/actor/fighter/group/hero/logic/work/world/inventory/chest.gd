extends Node

var chest_pos: Vector2 = Vector2.ZERO
var hero: CharacterBody2D
var chests: Node
var logic: Node

func enter_chest(border: TileMapLayer) -> void:
	chest_pos = hero.position + hero.logic.see.world.skills.chest.position
	print("ENTER THE CHEST!")

func exit_chest(_border: TileMapLayer) -> void:
	chest_pos = Vector2.ZERO
	print("EXIT THE CHEST!")

func _input(_event: InputEvent) -> void:
	if chest_pos != Vector2.ZERO and Input.is_action_just_pressed("action"):
		chests.open_chest(hero.logic.work.ui.inventory, chest_pos)
