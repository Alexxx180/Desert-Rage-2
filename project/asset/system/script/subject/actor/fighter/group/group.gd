extends Node2D

@export var is_overworld: bool = false
@export var deployed: bool = true
@onready var camera: Camera2D = $camera
@onready var xp: Node = $xp
@onready var ray: CharacterBody2D = $ray
@onready var rock: CharacterBody2D = $rock

var lay: Node
var navigation: Array
var deploy: HeroDeploy = HeroDeploy.new()

func _ready() -> void:
	var tags = get_node("../tags")
	if tags != null:
		lay = tags.lay
		lay.tags.layer.chests.group = self
	var party: Array[CharacterBody2D] = [ray, rock]
	deploy.init(self, party, deployed)
	if is_overworld: camera.set_overworld()
	for hero in party:
		hero.to.topdown.actions.board.set_value("group", self)

func is_hud_opened() -> bool:
	var result: bool = true
	for n in navigation:
		var last: bool = n.hud.logic.is_opened_last
		result = result and (not last)
	return not result

func _set_input(state: bool) -> void:
	for hero in deploy.party.heroes:
		hero.logic.work.input.suspended = state

func resume_input() -> void: if not is_hud_opened(): _set_input(false)

func suspend_input() -> void: _set_input(true)

func _input(event) -> void:
	if event.is_action_pressed("select") or (
		Input.is_action_pressed("mouse_select") and
		Input.is_action_just_released("mouse_select_2")):
		deploy.select()
	if event.is_action_pressed("deploy") or (
		Input.is_action_pressed("mouse_group") and
		Input.is_action_just_released("mouse_group_2")):
		deploy.regroup()
