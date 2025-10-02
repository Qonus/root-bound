shader_type canvas_item;

//uniform sampler2D height_map: source_color;
uniform sampler2D noise_texture: source_color;

uniform vec2 world_position = vec2(0.0);
uniform vec2 scale = vec2(2.0);

// GRASS REGIONS
const int MAX_CIRCLES = 100;
uniform vec3 circles[MAX_CIRCLES];
uniform int num_circles = 0;
uniform float smooth_factor = 0.1;
uniform float gradient = 20;

uniform vec4 background_colors[100]: source_color;
uniform int num_background_colors = 2;
uniform vec4 colors[100] : source_color;
uniform int num_colors = 2;

void vertex() {
	// Called for every vertex the material is visible on.
}

float sdf_circle(vec2 p, vec2 center, float radius) {
    return length(p - center) - radius;
}
float smooth_min(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void fragment() {
	vec4 noise_color = texture(noise_texture, UV);
	vec4 final_color = colors[int(noise_color.x * float(num_colors))];
	vec4 background_color = background_colors[int(noise_color.x * float(num_background_colors))];

	float combined_sdf = 999999.0;
	vec2 gl_uv = UV*scale - scale/2.0 + world_position;
	for (int i = 0; i < num_circles; i++) {
		vec2 circle_center = circles[i].xy;
		float circle_radius = circles[i].z;
		float current_sdf = sdf_circle(gl_uv, circle_center, circle_radius);
		if (circle_radius != 0.0) current_sdf /= gradient * circle_radius;
		combined_sdf = smooth_min(combined_sdf, current_sdf, smooth_factor);
    }
	float grass_factor = clamp(texture(noise_texture, UV).x-combined_sdf, 0.0, 1.0);
	if (grass_factor > 0.5) grass_factor = 1.0;
	//else grass_factor = 0.0;
	final_color = background_color + (final_color - background_color) * grass_factor;
	COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
