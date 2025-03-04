extends Node

signal ignite_fire()
signal freeze_fire()

func ignite() -> void:
	ignite_fire.emit()

func freeze() -> void:
	print("FROZEN")
	freeze_fire.emit()
