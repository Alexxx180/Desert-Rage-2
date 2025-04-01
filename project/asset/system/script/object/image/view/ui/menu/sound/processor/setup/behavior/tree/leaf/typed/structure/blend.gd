extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary

func branch(setup: Node, context: Variant) -> int:
	setup.leaf.set_blend(setup.ui, context)
	return OK
