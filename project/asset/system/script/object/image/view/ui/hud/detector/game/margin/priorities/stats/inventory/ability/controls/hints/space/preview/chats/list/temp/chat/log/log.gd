extends VBoxContainer

@onready var levels: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/preview/log/levels/levels.tscn")
@onready var items: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/preview/log/item.tscn")
@onready var scroll: ScrollContainer

func _ready() -> void:
	var s = get_node("../..")
	if s is ScrollContainer:
		scroll = s

func add_childs(stack: VBoxContainer, scene: PackedScene, feedback: Callable) -> PanelContainer:
	var node: PanelContainer = scene.instantiate()
	stack.add_child(node)
	feedback.call(node)
	return node

func add_log(scene: PackedScene, feedback: Callable) -> void:
	var lg: PanelContainer = add_childs(scroll.list.logs.chat, scene, feedback)
	var tween = create_tween()
	tween.tween_property(lg, "modulate", Color.TRANSPARENT, 0.5).set_delay(3)
	tween.tween_callback(func():
		scroll.list.logs.chat.remove_child(lg) # scroll.log
		lg.queue_free())
	add_childs(self, scene, feedback)
	scroll.down()

func set_priority(level: Node, stats: Dictionary) -> void:
	if level.summary != level.prev:
		add_log(levels, func(node): node.set_priority(level, stats))

func add_item(thing: String) -> void: add_log(items, func(n): n.chest(thing))
func add_enemy(thing: String) -> void: add_log(items, func(n): n.analyze(thing))
func add_any(thing: String) -> void: add_log(items, func(n): n.say(thing))
