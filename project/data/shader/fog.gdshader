shader_type canvas_item;

// Uniforms for customization
uniform sampler2D noise_texture : repeat_enable, filter_nearest;
uniform vec3 smoke_color : source_color = vec3(0.8);
uniform float distortion_speed : hint_range(0.0, 5.0) = 0.2;
uniform float density : hint_range(0.0, 1.0) = 0.75;
uniform float time1;

/*float final_noise(vec2 uv, float time) { //vec2 distorted_uv = uv * 0.1 - 0.05 + time; distorted_uv
	return texture(noise_texture, uv).r; // Create distorted UV and sample final noise
}

float smoke_alpha(vec2 uv, vec2 time) { // Sample noise with distortion
    vec4 noise = texture(noise_texture, uv + time.x);
	return final_noise(uv + noise.rg, time.y) * density;
}*/

float offtime(float offset) { return TIME * distortion_speed * offset; }

void fragment() { // Pre-calculate time-based offsets
	vec2 move = vec2(offtime(0.02), offtime(0.01));
	float noise = texture(noise_texture, UV + move).r;
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
    COLOR = vec4(smoke_color, fog * density);//smoke_alpha(UV, vec2(offtime(0.1), offtime(0.2))));
}