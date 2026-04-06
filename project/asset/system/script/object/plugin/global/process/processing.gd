class_name Works extends RefCounted

# Works.upload(self, _music, "res://asset/system/scene/subject/actor/group/music.tscn", "music")

static func turn(holder: Node, condition: bool) -> void:
	holder.process_mode = Node.PROCESS_MODE_INHERIT if condition else Node.PROCESS_MODE_DISABLED

static func bit(no: int) -> int: return 2 ** no

static func is_bit(value: int, index: int) -> bool:
	var digit: int = bit(index)
	return value & digit == digit

static func name_upload(parent: Node, ref: Node, caption: String) -> void:
	ref.name = caption
	parent.set("_" + caption, ref)
	parent.add_child(ref)

static func upload(parent: Node, ref: Node, path: String, caption: String) -> Node:
	if ref == null:
		ref = load(path).instantiate()
		name_upload(parent, ref, caption)
	return ref

static func upload_tree(parent: Node, ref: BehaviorTree, path: String, caption: String) -> BehaviorTree:
	if ref == null:
		ref = load(path).instantiate()
		name_upload(parent, ref, caption)
	return ref
