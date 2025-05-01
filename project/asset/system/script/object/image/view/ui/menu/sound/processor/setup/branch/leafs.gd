extends Node

func append_child(query: TreeOST, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func set_child(query: TreeOST, child) -> Control:
	var caption: String = query.caption
	var branch: Control = append_child(query, child, true)
	branch.name = caption
	branch.caption = caption
	return branch

func set_theme(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(track)
	query.ui_tree.set.push_back(branch)

func set_fight(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	for status in track:
		branch.content[status].set_metadata(track[status])
	query.ui_tree.set.push_back(branch)

func set_titled(query, child, tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(tracks[track])
	branch.set_title(track)
	query.ui_tree.set[track] = branch

func set_mix(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	# query.set_ui(branch.content.themes.body)

func set_blend(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	query.set_ui(branch.content.themes.body)

func set_alarm(query: TreeOST, child) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(query.context)
	query.ui_tree.set = branch

func include(query, child, setter, list, init) -> void:
	var tracks: Variant = query.context if list == "" else query.decide(list)
	query.ui_tree.set = init
	for track in tracks:
		setter.call(query, child, tracks, track)
