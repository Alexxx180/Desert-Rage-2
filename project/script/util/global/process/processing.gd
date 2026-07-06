class_name Works extends RefCounted

const hud: Dictionary = {}

static func _set_parent(parent: Object, ref: Variant, caption: String) -> void:
	parent.set("_" + caption, ref)

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

static func loads(caption: String, storage: Dictionary, feedback: Callable) -> Variant:
	if not storage.has(caption):
		storage[caption] = feedback.call()
	return storage[caption]

static func uploads(parent: Node, path: String, caption: String, storage: Dictionary, feedback: Callable) -> Variant:
	if not storage.has(caption): #  = HUD.REF
		storage[caption] = ref_upload(path, caption)
		parent.add_child(storage[caption])
		feedback.call(storage[caption])
	return storage[caption]

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
