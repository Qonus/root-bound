shader_type canvas_item;

uniform int size = 3;
uniform vec3 circles[100];
uniform vec2 world_position;

uniform float border_width = 1;

uniform vec4 border_color: source_color;
uniform vec4 inside_color: source_color;

float circle(vec2 uv, vec2 center, float radius)
{
	return length(uv - center) - radius;
}


void vertex()
{
}

void fragment()
{
	vec4 final_color = vec4(0.0, 0.0, 0.0, 0.0);
	for (int i = 0; i < size; i++) {
		vec2 center = circles[i].xy;
		float radius = circles[i].z;
		if (circle(UV, center, radius) <= 0.0) {
			final_color = inside_color;
		}
	}
	COLOR = final_color;
}