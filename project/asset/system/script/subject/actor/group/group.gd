extends Node2D

@export var deployed: bool = true
@onready var camera: Camera2D = $camera
@onready var _deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	_deploy.init(self, [$ray, $rock], deployed)

func _input(event) -> void:
	if event.is_action_pressed("select"):
		_deploy.select()
	if event.is_action_pressed("deploy"):
		_deploy.determine()
