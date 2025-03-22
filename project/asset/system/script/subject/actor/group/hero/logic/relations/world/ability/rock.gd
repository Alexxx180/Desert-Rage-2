extends Node

@onready var rain: Node = $rain
@onready var spark: Node = $spark

func controls(hero: CharacterBody2D, ability: Node, behavior: Node) -> void:
	rain.controls(hero, ability.rain, behavior.ability.puddle.rain)
	spark.controls(hero, ability.spark, behavior.ability.puddle.spark)
