extends CollisionShape2D

@onready var track: Dictionary = { name: self }
@onready var sides: Dictionary = { "left": front, "right": back }

func front(hero: float, box: float) -> bool: return hero > box
func back(hero: float, box: float) -> bool: return hero < box

func jump(hero: CharacterBody2D) -> void:
	if not sides.has(hero.direction):
		return
	var side = sides[hero.direction]
	for box in track:
		if ledge(side, hero, track[box]):
			return

func ledge(side: Callable, hero: Node2D, box: Node2D) -> bool:
	var can_jump: bool = side.call(hero.position.x, box.position.x)
	if can_jump: hero.position.x = box.position.x
	return can_jump

func _parallel(body: StaticBody2D) -> void: track.erase(body.name)
func intersect(body: StaticBody2D) -> void: track[body.name] = body
