extends Node2D

@export var is_overworld: bool = false
@export var deployed: bool = true
@onready var camera: Camera2D = $camera

var navigation: Array
var deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	deploy.init(self, [$ray, $rock], deployed)
	if is_overworld: camera.set_overworld()

func resume_input() -> void:
	var result: bool = true
	for n in navigation:
		print("UI: ", n.ui.name, " op: ", not n.hud.logic.is_opened_last)
		result = result and (not n.hud.logic.is_opened_last)
	print("RESUME IN: ", result)
	if not result: return
	for hero in deploy.party.heroes:
		hero.logic.processors.ui.input.resume_input()

func suspend_input() -> void:
	for hero in deploy.party.heroes:
		hero.logic.processors.ui.input.suspend_input()

func _input(event) -> void:
	if event.is_action_pressed("select") or (
		Input.is_action_pressed("mouse_select") and
		Input.is_action_just_released("mouse_select_2")):
		deploy.select()
	if event.is_action_pressed("deploy") or (
		Input.is_action_pressed("mouse_group") and
		Input.is_action_just_released("mouse_group_2")):
		deploy.regroup()
