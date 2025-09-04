extends Resource

class_name ActionButton

enum ActionButtonState { PRESSED = 0, TOGGLED = 1, RELEASED = 2 }

@export var state: ActionButtonState = ActionButtonState.PRESSED
@export var id: int
