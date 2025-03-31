extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(setup: Node, context: Variant) -> int:
	setup.leaf.standalone(setup.ui, context)
	return OK
