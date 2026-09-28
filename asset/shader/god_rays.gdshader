// God-ray / holy light beam for Godot 4 (2D)
// Put this on a ColorRect (or Sprite2D). The beam starts at the top edge and spreads downward.
shader_type canvas_item;
render_mode blend_add; // light adds onto the scene, so it glows instead of covering things

uniform vec4 beam_color : source_color = vec4(1.0, 0.92, 0.65, 1.0);
uniform float intensity : hint_range(0.0, 4.0) = 1.2;

// Beam shape (fractions of the rect width)
uniform float top_width : hint_range(0.0, 1.0) = 0.12;
uniform float bottom_width : hint_range(0.0, 1.0) = 0.7;
uniform float edge_softness : hint_range(0.01, 1.0) = 0.45;

// How the light fades out going down
uniform float fade_power : hint_range(0.1, 5.0) = 1.4;
uniform float top_fade : hint_range(0.0, 0.5) = 0.05;

// Individual rays / streaks inside the beam
uniform float ray_count : hint_range(1.0, 60.0) = 14.0;
uniform float ray_speed : hint_range(0.0, 3.0) = 0.35;
uniform float ray_strength : hint_range(0.0, 1.0) = 0.65;

// Floating dust sparkles
uniform float dust_amount : hint_range(0.0, 1.0) = 0.35;
uniform float dust_speed : hint_range(0.0, 1.0) = 0.05;

float hash(float n) { return fract(sin(n) * 43758.5453); }
float hash2(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

float noise1(float x) {
	float i = floor(x);
	float f = fract(x);
	f = f * f * (3.0 - 2.0 * f);
	return mix(hash(i), hash(i + 1.0), f);
}

void fragment() {
	vec2 uv = UV;

	// Position across the beam: -1 (left edge) .. 1 (right edge), widening as it goes down
	float width = mix(top_width, bottom_width, uv.y);
	float x = (uv.x - 0.5) / max(width, 0.0001) * 2.0;

	// Soft cone edges
	float cone = 1.0 - smoothstep(1.0 - edge_softness, 1.0, abs(x));

	// Rays: noise along x, so streaks fan out with the cone
	float r1 = noise1(x * ray_count + TIME * ray_speed);
	float r2 = noise1(x * ray_count * 0.63 - TIME * ray_speed * 0.7 + 17.0);
	float rays = mix(1.0, r1 * 0.6 + r2 * 0.6, ray_strength);

	// Fade: bright at the source, dim toward the bottom, softened right at the top
	float vfade = pow(1.0 - uv.y, fade_power) * smoothstep(0.0, top_fade + 0.0001, uv.y);

	// Dust motes drifting slowly downward
	vec2 grid = vec2(uv.x * 60.0, (uv.y - TIME * dust_speed) * 60.0);
	float d = hash2(floor(grid));
	float mote = step(0.985, d) * (1.0 - smoothstep(0.0, 0.35, length(fract(grid) - 0.5)));
	float twinkle = 0.5 + 0.5 * sin(TIME * 3.0 + d * 50.0);
	float dust = mote * twinkle * dust_amount;

	float a = cone * vfade * (rays + dust * 3.0) * intensity;
	COLOR = vec4(beam_color.rgb * a, a);
}
