shader_type canvas_item;

uniform vec2 hole_pos; // Normalized position (0.0 to 1.0)
uniform float hole_radius = 0.05;
uniform float softness = 0.01;
uniform vec4 color : source_color = vec4(1.0);

void fragment() {
    vec4 tex_color = color; //texture(TEXTURE, UV) * 
    float dist = distance(UV, hole_pos); // Calculate distance from current pixel to hole center
    float mask = smoothstep(hole_radius, hole_radius - softness, dist); // Create a smooth mask for the hole
    tex_color.a *= (1.0 - mask); // Apply hole (reduce alpha)
    COLOR = tex_color;
}