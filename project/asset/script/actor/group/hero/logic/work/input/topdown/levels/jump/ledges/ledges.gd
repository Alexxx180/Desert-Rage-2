class_name LedgeDeployment extends RefCounted

var jump: JumpDeployment
var data: Dictionary = {} # int, StaticBody2D
var that: StaticBody2D
var _direction: Vector2i = Vector2i.ZERO
var _plane: Array[Array] = []
var _try: bool = false
# var jumped: bool = false
var surface: Node2D

func determine() -> void: # print("determine jump")
	if around():
		jump.velo.set_box(Def.ic('jump on the box %s', that.box))
		jump.jump(that.box.pos)
	else:
		jump.velo.set_box(Def.ic('jump on the floor %s', HUD.ENTITY))
		jump.deploy()

func perform(motion: Vector2) -> void:
	surface.deploy.set_direction(motion) # print("overleaping: ", surface.overleap.is_colliding(motion))
	if not jump.stable or surface.border.is_colliding(motion):
		determine()
#	else:
#		print("can't perform")

func _init() -> void: jump = JumpDeployment.new()
func append(ledge: StaticBody2D) -> void: data[ledge.get_instance_id()] = ledge
func remove(ledge: StaticBody2D) -> void: data.erase(ledge.get_instance_id())
func around() -> bool: return _search(Def.ic("ledges size: ", data.size()), data.values())
func _more(x: float, y: float) -> bool: return x > y
func _less(x: float, y: float) -> bool: return x < y
func decide(axis: int) -> Array[Callable]: return [_side(axis, _between), _side(axis, _more), _side(axis, _less)]
func set_direction(direction: Vector2i) -> void: _direction = direction
func _for_direction(action: Callable) -> void: for axis in Def.vec2(): action.call(axis)
func setup(): _for_direction(func(a): _plane.push_back(decide(a)))

func _between(ledge: float, subject: float, GAP: int = 32) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _observe_ledge(axis: int, ledge: Vector2) -> void:
	_try = _try and _plane[axis][_direction[axis]].call(ledge)

func reach(stand: StaticBody2D) -> bool:
	return Def.ics("ACTUAL HEIGHT: %d, CAN: ", [_observe(stand.box.ledge), stand.box.height]) and jump.same(stand.box)

func _search(count: int, platforms: Array) -> bool:
	var jumped: bool = false
	while count > 0 and not jumped:
		count -= 1
		that = platforms[count]
		jumped = reach(that)
	return jumped

func _side(axis: int, align: Callable) -> Callable:
	return func(ledge: Vector2) -> bool:
		var state: Variant = jump.get_state()
		if state is CharacterBody2D:
			return align.call(ledge[axis], state.ledge[axis])
		else:
			return align.call(ledge[axis], state.position[axis])

func _observe(ledge: Vector2) -> bool:
	_try = true
	_for_direction(func(a): _observe_ledge(a, ledge))
	return _try
