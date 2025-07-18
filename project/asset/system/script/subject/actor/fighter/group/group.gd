extends Node2D

@export var is_overworld: bool = false
@export var deployed: bool = true
@onready var camera: Camera2D = $camera
# @onready 
var deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	deploy.init(self, [$ray, $rock], deployed)
	if is_overworld: camera.set_overworld()

func _input(event) -> void:
	if event.is_action_pressed("select"): deploy.select()
	if event.is_action_pressed("deploy"): deploy.regroup()
