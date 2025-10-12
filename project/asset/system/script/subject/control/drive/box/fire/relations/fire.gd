extends Node

signal activate(position: Vector2, damage: int)

const DAMAGE: int = 3

var _fire: Node2D
var _box: CharacterBody2D

var on: int:
	get: return _fire.detectors[0].monitoring

func _burn_fire(pos: Vector2):
	activate.emit(_box.position + pos, DAMAGE)

func set_fire(next: bool):
	_box.view.fire.emitting = next
	for area in _fire.detectors:
		area.monitoring = next

func _ignite() -> void:
	print("SET!")
	set_fire(true)
func _freeze() -> void: set_fire(false)

func controls(box: CharacterBody2D, fire: Node, trigger: Node) -> void:
	_fire = box.logic.see.fire
	for area in _fire.detectors:
		area.body_entered.connect(func(_execute: TileMapLayer): _burn_fire(area.position))
	_box = box

	activate.connect(trigger.activate)
	fire.ignite_fire.connect(_ignite)
	fire.freeze_fire.connect(_freeze)
