extends Node

var skills: Node

var hero: CharacterBody2D
var tags: TileMapLayer
var activator: Node:
	get: return tags.lockers.location.activator

func setup(h: CharacterBody2D, s: Node, t: TileMapLayer) -> void:
	hero = h ; tags = t ; skills = s

func start_forward(body: CharacterBody2D) -> void:
	skills.pull.start_forward(body, hero)

func stop_forward(body: CharacterBody2D) -> void:
	skills.pull.stop_forward(body, hero)

func transit(_body: CharacterBody2D) -> void:
	tags.transition.transit(hero)

func encounter_act(body: CharacterBody2D) -> void:
	skills.act.encounter(body, hero)

func diverge_act(body: CharacterBody2D) -> void:
	skills.act.diverge(body, hero)

func encounter_press(body: CharacterBody2D) -> void:
	skills.press.encounter(body, hero)

func diverge_press(body: CharacterBody2D) -> void:
	skills.press.diverge(body, hero)

func stomp_encounter(execute: TileMapLayer) -> void:
	skills.press.small_circle.enter_range(execute)

func stomp_diverge(execute: TileMapLayer) -> void:
	skills.press.small_circle.exit_range(execute)
