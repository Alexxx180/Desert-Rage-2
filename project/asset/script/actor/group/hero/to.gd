extends RefCounted
class_name HeroDependency
func _init(hero: CharacterBody2D) -> void: _hero = hero

var _hero: CharacterBody2D
# Input and physics genre logic
var input: Node:
	get: return _hero.logic.work.input
var topdown: Node:
	get: return input.topdown
var act: Node:
	get: return topdown.move.act
var jump: Node:
	get: return topdown.levels.jump
var F: int:
	get: return jump.feet.floors.F
var platformer: Node:
	get: return input.platformer
# World environment and skills
var moves: Node:
	get: return _hero.view.animation.moves
var effect: Node:
	get: return _hero.view.animation.effect
var world: Node:
	get: return _hero.logic.work.world
var layers: Lay:
	get: return world.layers
var stats: Node:
	get: return _hero.logic.work.stats
var state: Node:
	get: return stats.state
var hud: Node:
	get: return stats.hud
var chats: HBoxContainer:
	get: return hud.display.detector.game.controls.preview.chats

var inventory: Node:
	get: return world.inventory
# Eye sight detecting
var skills: Node2D:
	get: return _hero.logic.see.world.skills
var ability: Node2D:
	get: return _hero.logic.see.world.ability
var platform: Node2D:
	get: return _hero.logic.see.levels.platform
var tools: Node2D:
	get: return _hero.logic.see.levels.tools
