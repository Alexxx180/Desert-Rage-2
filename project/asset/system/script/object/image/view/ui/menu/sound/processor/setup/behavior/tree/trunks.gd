extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(setup: Node, context: Variant) -> int:
	setup.leaf.set_trunks(setup.ui, context)
	return OK
