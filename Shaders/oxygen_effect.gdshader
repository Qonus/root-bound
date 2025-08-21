shader_type canvas_item;

uniform vec2 world_position = vec2(0.0, 0.0);
uniform vec2 scale = vec2(1.0, 1.0);

const int MAX_CIRCLES = 100;
uniform vec3 circles[MAX_CIRCLES];
uniform int num_circles = 0;

uniform float smooth_factor = 0.1;
uniform float border_width = 0.01;

uniform vec4 border_color: source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform vec4 inside_color: source_color = vec4(0.0, 0.5, 0.7, 0.3);

uniform float wave_number = 2;
uniform float wave_amplitude = 0.005;
uniform float wave_speed = 1.0;

float sdf_circle(vec2 p, vec2 center, float radius) {
    return length(p - center) - radius;
}
float smooth_min(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void vertex() {
	//VERTEX += vec2(cos(TIME)*1.0, sin(TIME)*1.0);
}

void fragment() {
	vec2 uv = UV.xy;
	vec2 gl_uv = uv*scale*4.0 + world_position;

    float combined_sdf = 999999.0;
    for (int i = 0; i < num_circles; i++) {
        vec2 circle_center = circles[i].xy;
        float circle_radius = circles[i].z;
        float current_sdf = sdf_circle(gl_uv, circle_center, circle_radius);
		vec2 dir = circle_center - gl_uv;
		current_sdf += sin(atan(dir.x, dir.y) * wave_number + TIME * wave_speed) * wave_amplitude;
		combined_sdf = smooth_min(combined_sdf, current_sdf, smooth_factor);
    }

    vec4 final_color = vec4(0.0);
    if (abs(combined_sdf) < border_width) {
        final_color = border_color;
    } else if (combined_sdf < 0.0) {
        final_color = inside_color;
    }

    COLOR = final_color;
}