extends Node

@onready var hero: CharacterBody2D = get_node("../..")

var ledges: Dictionary = {}

var _subject: Vector2:
	get:
		return hero.position

func left(ledge: Vector2) -> bool: return ledge.x < _subject.x

func right(ledge: Vector2) -> bool: return _subject.x < ledge.x

func forward(ledge: Vector2) -> bool: return ledge.y < _subject.y

func backward(ledge: Vector2) -> bool: return _subject.y < ledge.y

func jump_to_direction(directions: Array[String]):
	for ledge in ledges:
		var i: int = directions.size()
		var jump: bool = self.call(directions[i], ledge.position)
		while i > 0 and jump:
			i = i - 1
			jump &= self.call(directions[i], ledge.position)
		if jump: hero.position = ledge.position

func append_ledge(ledge): ledges[ledge.get_instance_id()] = ledge
func remove_ledge(ledge): ledges.erase(ledge)
