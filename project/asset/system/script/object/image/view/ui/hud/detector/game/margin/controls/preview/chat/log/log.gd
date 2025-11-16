extends PanelContainer

@onready var chat: VBoxContainer = $margin/chat
@onready var levels: PackedScene = preload("res://asset/system/scene/object/canvas/ui/hud/detector/game/preview/log/levels/levels.tscn")
@onready var scroll: ScrollContainer = get_node("../..")

func add_childs(stack: VBoxContainer, scene: PackedScene, feedback: Callable) -> PanelContainer:
	var node: PanelContainer = scene.instantiate()
	stack.add_child(node)
	feedback.call(node)
	return node

func add_log(scene: PackedScene, feedback: Callable) -> void:
	var log: PanelContainer = add_childs(scroll.log, scene, feedback)
	var tween = create_tween()
	tween.tween_property(log, "modulate", Color.TRANSPARENT, 0.5).set_delay(3)
	tween.tween_callback(func():
		scroll.log.remove_child(log)
		log.queue_free())
	add_childs(chat, scene, feedback)
	scroll.down()

func set_priority(level: Node, stats: Dictionary) -> void:
	add_log(levels, func(node): node.set_priority(level, stats))
