extends Resource

class_name ActionButton

enum STATE { PRESSED = 0, TOGGLED = 1, RELEASED = 2 }

@export var state: STATE = STATE.PRESSED
@export var id: int
