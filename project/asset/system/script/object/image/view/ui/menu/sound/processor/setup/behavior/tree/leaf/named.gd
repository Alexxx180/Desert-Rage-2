extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set.values()[0] is String

func branch(setup: Node, context: Variant) -> int:
	setup.leaf.named(setup.ui)
	return OK
