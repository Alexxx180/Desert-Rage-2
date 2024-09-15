extends RefCounted

class_name PushTrack

var distance: Vector2
var velocity: int

func _init(box: Node, hero: Node, power: int) -> void:
	distance = box.size.sub(hero.size)
	velocity = power

static func plane(box: Node, hero: Node, power: int) -> Array[PushTrack]:
	return [PushTrack.new(box, hero, -power), PushTrack.new(hero, box, power)]
