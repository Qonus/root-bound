shader_type canvas_item;

uniform float fill_level = 0.5;

uniform vec4 color: source_color = vec4(0.0);
uniform vec4 secondary_color: source_color = vec4(0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 final_color = color;
	float sin1 = 0.05*sin(9.0*UV.x + 3.0*TIME)+1.0-fill_level*1.1+0.06;
	float sin2 = 0.03*sin(10.0*UV.x - 4.0*TIME)+1.0-fill_level*1.1;
	if (UV.y > sin2 && UV.y < sin1) final_color = secondary_color;
	else if (UV.y < sin1) final_color.a = 0.0;

	COLOR = final_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
