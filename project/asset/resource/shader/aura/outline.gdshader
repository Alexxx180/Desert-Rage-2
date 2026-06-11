shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform bool action = false;
uniform bool invisible = false;
uniform float ap : hint_range(0.0, 1.0) = 0.5; // Resource view control

const vec4 invisible_line = vec4(0.5, 0.5, 0.5, 1);
const float invisible_thick = 5.0;
const float ap_color = 12.0;
const vec2 OFFSETS[8] = { vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), vec2(1, -1), vec2(1, 0), vec2(1, 1) };

vec4 resource(vec4 color, float y) {
	if (!action) {
		if (invisible) { return color * vec4(0, 0, 0, 1); }
		return color;
	}
	vec2 value = vec2(1.0 - ap, y + (1.0 - ap) * 0.75);
	if (value.y > value.x) {
		color *= vec4(0, 0, ap_color, 1);
	} else if (invisible) {
		color *= vec4(0, 0, 0, 255);
	}
	return color;
}

float draw_outline(sampler2D image, vec2 size, vec2 uv) {
	float outline = 0.0;
	for (int i = 0; i < OFFSETS.length(); i++) {
		outline += texture(image, uv + size * OFFSETS[i]).a;
	}
	return min(outline, 1.0);
}

void fragment() {
	vec4 color = resource(texture(TEXTURE, UV), UV.y);
	if (invisible) {
		COLOR = mix(color, invisible_line, draw_outline(TEXTURE, TEXTURE_PIXEL_SIZE * invisible_thick, UV) - color.a);
	} else {
		COLOR = mix(color, line_color, draw_outline(TEXTURE, TEXTURE_PIXEL_SIZE * line_thickness, UV) - color.a);
	}
}