extends Node

func get_leaf(user: Dictionary, copy: Dictionary) -> Dictionary:
	return user if user.has("set") and user.set.size() > 0 else copy

func decide(key: String, user: Dictionary, copy: Dictionary) -> Dictionary:
	return user[key] if user.has(key) else copy[key]
