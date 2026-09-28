shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

uniform float inner_radius : hint_range(0.0, 1.5) = 0.35;
uniform float outer_radius : hint_range(0.0, 1.5) = 1.0;

void fragment() {
	vec2 centered = UV * 2.0 - 1.0;
	float edge = smoothstep(inner_radius, outer_radius, length(centered));
	COLOR = vec4(flash_color.rgb, flash_color.a * edge * intensity);
}
