extends Node2D

@export var is_overworld: bool = false
@export var deployed: bool = true
@onready var camera: Camera2D = $camera
@onready var xp: Node = $xp

var navigation: Array
var deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	var ray: CharacterBody2D = $ray
	deploy.init(self, [ray, $rock], deployed)
	if is_overworld: camera.set_overworld()
	ray.logic.processors.ui.input.board.set_value("group", self)

func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		result = result and (not n.hud.logic.is_opened_last)
	return not result

func resume_input() -> void:
	if is_hud_opened(): return
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
