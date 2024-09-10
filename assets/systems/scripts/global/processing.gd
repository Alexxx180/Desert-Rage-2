extends Node

class_name Processors

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

func enable(condition: bool) -> ProcessMode:
	return will if condition else wont
