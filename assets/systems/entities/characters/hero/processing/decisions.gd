extends Node

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

func decide(condition: bool) -> ProcessMode:
	return will if condition else wont
