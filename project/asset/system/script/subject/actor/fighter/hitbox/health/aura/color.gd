extends Node

class_name AuraHealthColor

enum { NO = 0, SEMI = 100, SET = 255 }

var colors: Dictionary = { "BLUE": 1.0, "GREEN": 0.8, "YELLOW": 0.4, "RED": 0.0 }

func decide(a: String, b: String, segment: float) -> float:
	return 1.0 / (colors[a] - colors[b]) * (segment - colors[b])

func green(segment: float) -> Color:
	return Color.from_rgba8(NO, SET, int(SET * decide("BLUE", "GREEN", segment)), SEMI)

func yellow(segment: float) -> Color:
	var color: float =  1.0 - decide("GREEN", "YELLOW", segment)
	return Color.from_rgba8(int(color * SET), SET, NO, SEMI)

func red(segment: float) -> Color:
	return Color.from_rgba8(SET, int(SET * decide("YELLOW", "RED", segment)), NO, SEMI)

func diffuse() -> Color:
	return Color.from_rgba8(NO, NO, NO, NO)

func get_color(segment: float) -> Color:
	if segment <= colors.RED: return Color.from_rgba8(SET, NO, NO, SEMI)
	if segment >= colors.BLUE: return Color.from_rgba8(NO, SET, SET, SEMI)
	
	for part in [[green, "GREEN", "BLUE"], [yellow, "YELLOW", "GREEN"]]:
		if colors[part[1]] <= segment and segment < colors[part[2]]:
			return part[0].call(segment)
	
	return red(segment)
