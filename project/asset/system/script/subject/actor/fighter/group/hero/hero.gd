extends CharacterBody2D

@export var stats: EntityStats
@onready var group: Node2D = get_parent()
@onready var to: HeroDependency = HeroDependency.new(self)

var _view: Node2D = null
var view: Node2D:
	get:
		if (_view == null):
			var asset = preload("res://asset/system/scene/subject/actor/group/hero/base/view/rock.tscn")
			_view = asset.instantiate()
			add_child(_view)
		return _view

var _logic: Node2D = null
var logic: Node2D:
	get:
		if (_logic == null):
			var asset = preload("res://asset/system/scene/subject/actor/group/hero/rock/logic/logic.tscn")
			_logic = asset.instantiate()
			_logic.stats = stats
			add_child(_logic)
			_logic.link.controls(self)
			to.topdown.actions.board.s("group", group)
		return _logic

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion
