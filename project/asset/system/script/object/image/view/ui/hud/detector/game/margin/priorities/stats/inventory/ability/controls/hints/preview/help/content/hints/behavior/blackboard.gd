extends BehaviorBlackboard

func toggle_value(key: String) -> BehaviorBlackboard:
	return s(key, !g(key))
