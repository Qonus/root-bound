shader_type particles;

//uniform sampler2D height_map: source_color;
uniform sampler2D noise_texture: source_color;

uniform vec2 world_position = vec2(0);
uniform vec2 size = vec2(2.0);
uniform int amount = 10;

// GRASS REGIONS
const int MAX_CIRCLES = 1024;
uniform vec3 circles[MAX_CIRCLES];
uniform int num_circles = 0;
uniform float smooth_factor = 0.1;
uniform float gradient = 20.0;

// ATTRACTOR FORCES
const int MAX_ATTRACTOR_FORCES = 1024;
uniform vec3 attractor_forces[MAX_ATTRACTOR_FORCES];
uniform int num_attractor_forces = 1;
uniform float force_multiplier = 1.0;

// WIND PROPERTIES
uniform float sway = 0.3;
uniform float speed = 5.0;
uniform float phase_difference = 5.0;

// GRASS PROPERTIES
uniform float grass_width = 0.5;
uniform float grass_height = 2.0;

// COLOR
uniform vec4 background_colors[100]: source_color;
uniform int num_background_colors = 2;
uniform vec4 colors[100] : source_color;
uniform int num_colors = 2;

float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}
uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}
float sdf_circle(vec2 p, vec2 center, float radius) {
    return length(p - center) - radius;
}
float smooth_min(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

void start() {
	float square_size = sqrt(size.x * size.y/float(amount));
	float cols = size.x / square_size;
	float rows = size.y / square_size;

	float col_id = mod(float(INDEX), cols);
	float row_id = mod(floor(float(INDEX) / cols), rows);

	uint alt_seed1 = hash(INDEX + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(INDEX + uint(27) + RANDOM_SEED);

	vec2 uv = vec2(col_id, row_id) + vec2(rand_from_seed(alt_seed1),
                   rand_from_seed(alt_seed2));
	uv /= vec2(cols, rows);
	vec2 pos = uv * size - size/2.0;
	vec2 gl_uv = pos + world_position;

//	GRASS_REGIONS
	float combined_sdf = 999999.0;
	for (int i = 0; i < num_circles; i++) {
		vec2 circle_center = circles[i].xy;
		float circle_radius = circles[i].z;
		float current_sdf = sdf_circle(gl_uv, circle_center, circle_radius);
		if (circle_radius != 0.0) current_sdf /= gradient*circle_radius;
		combined_sdf = smooth_min(combined_sdf, current_sdf, smooth_factor);
    }

//	ATTRACTOR FORCES
	vec2 net_force = vec2(0.0);
	for (int i = 0; i < num_attractor_forces; i++) {
		vec2 center = attractor_forces[i].xy;
		float force = attractor_forces[i].z;
		vec2 dir = gl_uv - center;
		net_force += normalize(dir)/length(dir) * force * force_multiplier;
	}
	float bend_x = -atan(net_force.x * length(net_force));
	float bend_y = net_force.y;

	float grass_factor = clamp(texture(noise_texture, uv).x-combined_sdf, 0.0, 1.0);
	float height = grass_factor * grass_height;
	if (grass_factor < 0.5) height = 0.0;

//	SCALING
	mat4 scale_mat = mat4(
	    vec4(grass_width, 0.0, 0.0, 0.0),
	    vec4(0.0, height, 0.0, 0.0),
	    vec4(0.0, 0.0, 1.0, 0.0),
	    vec4(0.0, -height/2.0, 0.0, 1.0)
	);

//	ROTATION
	float angle = bend_x + sin(phase_difference*(uv.x + uv.y) + TIME*speed) * sway; // or a uniform/attribute
	float c = cos(angle);
	float s = sin(angle);
	mat4 rot_z = mat4(
	    vec4(c, -s, 0.0, 0.0),
	    vec4(s,  c, 0.0, 0.0),
	    vec4(0.0, 0.0, 1.0, 0.0),
	    vec4(0.0, 0.0, 0.0, 1.0)
	);

//	POSITIONING
	TRANSFORM = EMISSION_TRANSFORM;
	TRANSFORM[3] = vec4(gl_uv, 0, 0);

	TRANSFORM = TRANSFORM * rot_z * scale_mat;

//	COLOR
	vec4 noise_color = texture(noise_texture, uv);
	vec4 final_color = colors[int(noise_color.x * float(num_colors))];
	vec4 background_color = background_colors[int(noise_color.x * float(num_background_colors))];
	//final_color = background_color + (final_color - background_color) * grass_factor;
	final_color.a = 1.0-length(net_force)/5.0;
	COLOR = final_color;
}

void process() {
	// Called every frame on existing particles (according to the Fixed FPS property).
}
