extends Node

class_name BehaviorTreeBase

func _execute(mark: Tick) -> int:
	_enter(mark)

	if not mark.blackboard.get_value('isOpen', mark.tree, self):
		_open(mark)

	var status := _tick(mark)
	if status != ERR_BUSY: _close(mark)

	_exit(mark)
	return status

func _enter(mark: Tick) -> void:
	# debug call to be filled out in tick object
	mark.enter_node(self) 
	enter(mark)

func _open(mark: Tick) -> void:
	mark.open_node(self)
	mark.blackboard.set_value('isOpen', true, mark.tree, self)
	open(mark)

func _tick(mark: Tick) -> int:
	mark.tick_node(self)
	return tick(mark)

func _close(mark: Tick) -> void:
	mark.close_node(self)
	mark.blackboard.set_value('isOpen', false, mark.tree, self)
	close(mark)

func _exit(mark: Tick) -> void:
	mark.exit_node(self)
	exit(mark)

# To be overriden
func enter(_mark: Tick) -> void: pass
func open(_mark: Tick) -> void: pass
func tick(_mark: Tick) -> int: return OK
func close(_mark: Tick) -> void: pass
func exit(_mark: Tick) -> void: pass
