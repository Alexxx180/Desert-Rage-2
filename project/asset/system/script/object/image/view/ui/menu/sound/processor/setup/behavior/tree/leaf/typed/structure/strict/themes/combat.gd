extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.size() > 0 and data[0] is Dictionary

func branch(setup: Node, context: Variant) -> int:
	setup.leaf.set_combat(setup.ui, context)
	return OK
