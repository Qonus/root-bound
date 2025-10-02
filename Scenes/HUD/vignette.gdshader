shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec4 color: source_color = vec4(0.0);
uniform float noise = 0.5;
uniform sampler2D noise_texture;

float sdf_circle(vec2 p, vec2 center, float radius) {
    return length(p - center) - radius;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 final_color = color;
	float sdf = sdf_circle(UV, vec2(0.5, 0.5), 0.75 - strength*0.25);
	if (sdf+texture(noise_texture, UV).x*noise < 0.0) final_color.a = 0.0;
	COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
