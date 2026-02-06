extends Node2D

@onready var view: Sprite2D = $view

var rotate: float
var directed: int = 1

enum { OFF = 3, Z = 0, HALF = 90, AIM = 180 }

func t(direction: String) -> String:
	return "targeting_" + direction

func w(d: String) -> String:
	return t(d + "ward")

#func _physics_process(delta: float) -> void:
#	view.rotation_degrees += rotate * directed * OFF

func diag(a: String, b: String) -> bool:
	return Input.is_action_pressed(a) and Input.is_action_pressed(b)

func dir(a: String) -> bool:
	return Input.is_action_pressed(a)

func _input(event: InputEvent) -> void:
	var vec = Input.get_vector(t("left"), t("right"), w("for"), w("back"))
	
	var y: int = vec.y * HALF + HALF * abs(vec.y)
	var x: int = -vec.x * HALF# + HALF * abs(vec.x)
	
	if x != 0 or y != 0:
		view.rotation_degrees = x + y
	
	"""
	if w("for") != 0:
		pass
	elif w("back") != 0:
		pass
	view.rotation_degrees
	var t = Input.get_axis(w("for"), w("back"))
	if diag(w("for"), t("left")):
		rotate *= 2
		#view.rotation_degrees = AIM
	elif diag(w("back"), t("right")):
		rotate *= 2
		# view.rotation_degrees = Z
	elif dir(t("right")):
		view.rotation_degrees = AIM # -(AIM / 2)
	elif dir(t("left")):
		view.rotation_degrees = Z # AIM / 2
	# rotate = Input.get_vector(t("left"), t("right"), w("for"), w("back"))
	"""
