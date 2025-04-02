func add_child(query: SoundtrackTreeQuery, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func set_child(query: SoundtrackTreeQuery, child) -> Control:
	var caption: String = query.caption
	var branch: Control = _add_child(query, child, true)
	branch.caption = caption
	return branch

func set_theme(query, child, _tracks, track) -> void:
	var branch: Control = _add_child(query, child)
	branch.set_metadata(track)

func set_fight(query, child, tracks, track) -> void:
	var branch: Control = _add_child(query, _fight)
	for status in track:
		branch.content[status].set_metadata(track[status])

func set_titled(query, child, tracks, track) -> void:
	var branch: Control = _add_child(query, child)
	branch.set_metadata(tracks[track])
	branch.set_title(track)

func set_blend(query, child, mix: int) -> void:
	var branch: Control = set_child(query, child[query.pad])
	branch.set_metadata(mix)

func set_alarm(query: SoundtrackTreeQuery, child) -> void:
	var branch: Control = leafs.add_child(query, child)
	branch.set_metadata(query.context[1])
	branch.set_alarm(query.context[0])

func include(query, child, setter, list = "") -> void:
	var tracks: Variant = query.context if list == "" else query.decide(list)
	for track in tracks:
		setter.call(query, child, tracks, track)
