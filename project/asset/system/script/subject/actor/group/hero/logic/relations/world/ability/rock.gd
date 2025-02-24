extends Node

@onready var rain: Node = $rain
@onready var spark: Node = $spark

func controls(hero: CharacterBody2D, ability: Node, activators: Node) -> void:
	rain.controls(hero, ability.rain, activators.ability.puddle.rain)
	spark.controls(hero, ability.spark, activators.ability.puddle.spark)
