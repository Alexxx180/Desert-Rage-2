class_name AuraHealthColor extends Node

enum { NO = 0, SEMI = 100, SET = 255 }
enum { BLUE, GREEN, YELLOW, RED }

var color: PackedFloat32Array = [1.0, 0.8, 0.4, 0.0]

func decide(a: int, b: int, segment: float) -> float:
	return 1.0 / (color[a] - color[b]) * (segment - color[b])

func green(segment: float) -> Color:
	return Color.from_rgba8(NO, SET, int(SET * decide(BLUE, GREEN, segment)), SEMI)

func yellow(segment: float) -> Color:
	return Color.from_rgba8(int((1.0 - decide(GREEN, YELLOW, segment)) * SET), SET, NO, SEMI)

func red(segment: float) -> Color:
	return Color.from_rgba8(SET, int(SET * decide(YELLOW, RED, segment)), NO, SEMI)

func diffuse() -> Color: return Color.from_rgba8(NO, NO, NO, NO)

func get_color(segment: float) -> Color:
	if segment <= color[RED]: return Color.from_rgba8(SET, NO, NO, SEMI)
	if segment >= color[BLUE]: return Color.from_rgba8(NO, SET, SET, SEMI)
	
	for part in [[green, GREEN, BLUE], [yellow, YELLOW, GREEN]]:
		if color[part[1]] <= segment and segment < color[part[2]]:
			return part[0].call(segment)
	return red(segment)
