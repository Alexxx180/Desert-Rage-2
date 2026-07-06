shader_type canvas_item;

uniform sampler2D mask;
uniform vec2 offset = vec2(0, 0);

void fragment() {
	COLOR.rgb = texture(TEXTURE, UV + offset).rgb; //# Or COLOR.rgb = COLOR.rgb, for control nodes.
	COLOR.a = texture(mask, UV + offset).r;
}