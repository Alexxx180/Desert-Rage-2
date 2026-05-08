class_name Works extends RefCounted

const hud: Dictionary = {}

static func on(holder: Node, state: bool) -> void: holder.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED
static func off(holder: Node) -> bool: return holder.process_mode == Node.PROCESS_MODE_DISABLED

static func bit(no: int) -> int: return 2 ** no
static func is_bit(value: int, index: int) -> bool:
	var digit: int = bit(index)
	return value & digit == digit

static func _set_parent(parent: Object, ref: Variant, caption: String) -> void:
	parent.set("_" + caption, ref)

static func lazy(parent: Object, ref: Variant, caption: String) -> Variant:
	if ref != null: _set_parent(parent, ref, caption)
	return ref

static func pload(parent: Node, path: PackedScene, caption: String, feedback: Callable = HUD.FUNC) -> Variant:
	if not HUD.REF.has(caption):
		HUD.REF[caption] = path.instantiate()
		parent.add_child(HUD.REF[caption])
		if feedback != HUD.FUNC: feedback.call(HUD.REF[caption])
	return HUD.REF[caption]

static func ref_upload(path: String, caption: String) -> Variant:
	var ref: Variant = load(path).instantiate()
	if caption.contains('/'):
		caption = caption.substr(caption.rfind('/') + 1)
	ref.name = caption
	return ref

static func name_upload(parent: Node, path: String, caption: String) -> Variant:
	var ref: Variant = ref_upload(path, caption)
	parent.set("_" + caption, ref)
	return ref

static func inits(parent: Node, ref: Variant, caption: String, logic: Callable) -> Variant:
	if ref == null:
		ref = logic.call()
		parent.set("_" + caption, ref)
	return ref

static func uploads(parent: Node, path: String, caption: String, feedback: Callable = HUD.FUNC) -> Variant:
	if not HUD.REF.has(caption):
		HUD.REF[caption] = ref_upload(path, caption)
		parent.add_child(HUD.REF[caption])
		if feedback != HUD.FUNC:
			feedback.call(HUD.REF[caption])
	return HUD.REF[caption]

static func upload(parent: Node, ref: Variant, path: String, caption: String) -> Variant:
	if ref == null:
		ref = name_upload(parent, path, caption)
		parent.add_child(ref)
	return ref

static func _upload_at(parent: Node, sibling: Node, ref: Variant, path: String, caption: String) -> Variant:
	ref = name_upload(parent, path, caption)
	sibling.add_sibling(ref)
	return ref

static func upload_at(parent: Node, sibling: Node, ref: Variant, path: String, caption: String) -> Variant:
	if ref == null: ref = _upload_at(parent, sibling, ref, path, caption)
	return ref

static func upload_hold(parent: Node, holder: String, ref: Variant, path: String, caption: String) -> Variant:
	if ref == null:
		var sibling: Node = parent.get_node(holder)
		ref = _upload_at(parent, sibling, ref, path, caption)
		parent.remove_child(sibling)
	return ref
