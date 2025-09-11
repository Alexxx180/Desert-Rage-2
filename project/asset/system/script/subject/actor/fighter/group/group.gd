extends Node2D

signal update_stats()
signal update_exp()

@export var is_overworld: bool = false
@export var deployed: bool = true
@onready var camera: Camera2D = $camera

const MAX_LV: int = 7

var navigation: Array
var deploy: HeroDeploy = HeroDeploy.new()
var summary: Dictionary

func _circle_level_up() -> void:
	var lv: int = 0
	while summary.xp >= summary.next:
		lv += 1
		summary.

func add_exp(amount: int) -> void:
	summary.xp += amount
	if summary.xp >= next:
		_circle_level_up()
	update_exp.emit()
	
	upate_stats.emit()

func _ready() -> void:
	deploy.init(self, [$ray, $rock], deployed)
	if is_overworld: camera.set_overworld()
	summary = {
		"xp": 0, "next": 10, "priorities": {
			"ray": { "at": 0, "of": [0, 0, 0], "points": { "h": 9, "a": 11 }, },
			"rock": { "at": 0, "of": [0, 0, 0], "points": { "h": 11, "a": 9 } },
		}
	}
	for hero in deploy.party.heroes:
		hero.logic.processors.stats.summary = summary

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
