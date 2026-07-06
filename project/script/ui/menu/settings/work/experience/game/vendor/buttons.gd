extends Node

enum { A = JOY_BUTTON_A, B = JOY_BUTTON_B, X = JOY_BUTTON_X, Y = JOY_BUTTON_Y }

var vendor: bool = false
var reorder: bool = false
var order_a: bool = false
var order_x: bool = true

func result(button: Vector2i, ord: bool) -> int: return button.x if ord else button.y
func branch(group: Vector2i, a: int, ord: bool) -> int: return result(group, ord) if reorder else a
func gets(home: Vector2i, verge: Vector2i, x: bool, y: bool) -> int:
	if order_a: return branch(Vector2i(home.x, home.y), verge.x, order_x)
	return branch(Vector2i(home.y, home.x), verge.y, order_x)

const S: Rect2i = Rect2i(Vector2i(A, B), Vector2i(X, Y))
const R: Rect2i = Rect2i(Vector2i(B, A), Vector2i(Y, X))

func order(code: int) -> int:
	match code:
		JOY_BUTTON_A: return gets(R.size, R.position, order_a, order_x)
		JOY_BUTTON_B: return gets(S.size, S.position, order_a, order_x)
		JOY_BUTTON_X: return gets(R.position, R.size, order_x, order_a)
		JOY_BUTTON_Y: return gets(S.position, S.size, order_x, order_a)
	return code
