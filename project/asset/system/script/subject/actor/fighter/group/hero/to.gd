extends RefCounted
class_name HeroDependency
func _init(hero: CharacterBody2D) -> void: _hero = hero

var _hero: CharacterBody2D
# Input and physics genre logic
var topdown: Node:
	get: return _hero.logic.work.input.topdown
var platformer: Node:
	get: return _hero.logic.work.input.platformer
# World environment and skills
var effect: Node:
	get: return _hero.view.animation.effect
var world: Node:
	get: return _hero.logic.work.world
var layers: Node:
	get: return world.layers
var stats: Node:
	get: return _hero.logic.work.stats
var hud: Node:
	get: return stats.hud
# Eye sight detecting
var skills: Node2D:
	get: return _hero.logic.see.world.skills
var platform: Node2D:
	get: return _hero.logic.see.levels.platform
var tools: Node2D:
	get: return _hero.logic.see.levels.tools
