extends Node

signal activate(position: Vector2, damage: int)

const DAMAGE: int = 3

var _fire: Area2D
var _box: CharacterBody2D

var on: int:
	get: return _fire.monitoring

func _burn_fire(_execute: TileMapLayer):
	activate.emit(_box.position + _fire.position, DAMAGE)

func set_fire(next: bool):
	_box.view.fire.emitting = next
	_fire.monitoring = next

func _ignite() -> void:
	print("SET!")
	set_fire(true)
func _freeze() -> void: set_fire(false)

func controls(box: CharacterBody2D, fire: Node, trigger: Node) -> void:
	_fire = box.logic.detectors.fire
	_fire.body_entered.connect(_burn_fire)
	_box = box

	activate.connect(trigger.activate)
	fire.ignite_fire.connect(_ignite)
	fire.freeze_fire.connect(_freeze)
