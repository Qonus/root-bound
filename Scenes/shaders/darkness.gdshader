shader_type canvas_item;

uniform vec4 color: source_color;
uniform vec4 border_color: source_color;
uniform float border_width = 5.0;

uniform vec2 world_position = vec2(0.0, 0.0);
uniform vec2 scale = vec2(1.0, 1.0);

const int MAX_CIRCLES = 100;
uniform vec3 circles[MAX_CIRCLES];
uniform int num_circles = 0;

uniform float smooth_factor = 0.1;

uniform float noise = 2.0;
uniform sampler2D noise_texture;

float sdf_circle(vec2 p, vec2 center, float radius) {
    return length(p - center) - radius;
}
float smooth_min(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV.xy;
	vec2 gl_uv = uv*scale*4.0 + world_position;

    float combined_sdf = 999999.0;
	float combined_border_sdf = combined_sdf;
    for (int i = 0; i < num_circles; i++) {
		vec2 circle_center = circles[i].xy;
		float circle_radius = circles[i].z;
		float current_sdf = sdf_circle(gl_uv, circle_center, circle_radius);
		vec2 dir = circle_center - gl_uv;
		combined_sdf = smooth_min(combined_sdf, current_sdf, smooth_factor);
		combined_border_sdf = smooth_min(combined_border_sdf, current_sdf - border_width*circle_radius, smooth_factor);
    }

    vec4 final_color = vec4(0.0);
	float gradient = noise*texture(noise_texture, UV).x;
    if (gradient + combined_sdf > 0.0 && gradient + combined_border_sdf < 0.0) {
        final_color = border_color;
    } else if (gradient + combined_border_sdf > 0.0) {
		final_color = color;
	}

    COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
