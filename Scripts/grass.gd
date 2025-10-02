@tool
class_name GrassShader
extends Node2D

@export_category("Grass Region Properties")
@export var smooth_factor: float = 0.1
@export var gradient: float = 20.0
@export var size: Vector2
@export var circles: Array[Circle] = []
#@export var height_map: ImageTexture

@export_category("Colors")
@export var noise_texture: Texture2D
@export var background_colors: Array[Color]
@export var colors: Array[Color]

@export_category("Grass Particles")
@export var amount_of_grass: int = 1000
@export var grass_height: float = 6.0;
@export var grass_width: float = 1.5;
@export var attractor_forces: Array[Circle] = []

@export_category("Wind")
@export var sway: float = 0.3
@export var speed: float = 5.0
@export var phase_difference: float = 5.0

@export_category("Play")
@export var node: Node2D = null

var flat_grass: Sprite2D
var grass_particles: GPUParticles2D
func _ready() -> void:
	#height_map = ImageTexture.new()
	#var image = Image.create_empty(noise_texture.get_size().x,noise_texture.get_size().y,false,Image.FORMAT_RGBA8)
	#image.fill(Color(1.0, 1.0, 1.0, 1.0))
	#height_map.set_image(image)
	flat_grass = $FlatGrass
	grass_particles = $GrassParticles

func _process(delta: float) -> void:
	#flat_grass.material.set("shader_parameter/height_map", height_map)
	flat_grass.material.set("shader_parameter/circles", circles.map(func (circle: Circle): return Vector3(circle.position.x, circle.position.y, circle.radius)))
	flat_grass.material.set("shader_parameter/num_circles", circles.size())
	flat_grass.material.set("shader_parameter/smooth_factor", smooth_factor)
	flat_grass.material.set("shader_parameter/gradient", gradient)
	
	flat_grass.material.set("shader_parameter/noise_texture", noise_texture)
	flat_grass.material.set("shader_parameter/background_colors", background_colors)
	flat_grass.material.set("shader_parameter/num_background_colors", background_colors.size())
	flat_grass.material.set("shader_parameter/colors", colors)
	flat_grass.material.set("shader_parameter/num_colors", colors.size())
	
	flat_grass.material.set("shader_parameter/scale", size)
	flat_grass.material.set("shader_parameter/world_position", global_position)
	
	flat_grass.scale = size
	
	#grass_particles.process_material.set("shader_parameter/height_map", height_map)
	grass_particles.process_material.set("shader_parameter/circles", circles.map(func (circle: Circle): return Vector3(circle.position.x, circle.position.y, circle.radius)))
	grass_particles.process_material.set("shader_parameter/num_circles", circles.size())
	grass_particles.process_material.set("shader_parameter/smooth_factor", smooth_factor)
	grass_particles.process_material.set("shader_parameter/gradient", gradient)
	grass_particles.process_material.set("shader_parameter/attractor_forces", attractor_forces.map(func (circle: Circle): return Vector3(circle.position.x, circle.position.y, circle.radius)))
	grass_particles.process_material.set("shader_parameter/num_attractor_forces", attractor_forces.size())
	
	grass_particles.process_material.set("shader_parameter/noise_texture", noise_texture)
	grass_particles.process_material.set("shader_parameter/background_colors", background_colors)
	grass_particles.process_material.set("shader_parameter/num_background_colors", background_colors.size())
	grass_particles.process_material.set("shader_parameter/colors", colors)
	grass_particles.process_material.set("shader_parameter/num_colors", colors.size())
	
	grass_particles.process_material.set("shader_parameter/grass_width", grass_width)
	grass_particles.process_material.set("shader_parameter/grass_height", grass_height)
	grass_particles.process_material.set("shader_parameter/size", size)
	grass_particles.process_material.set("shader_parameter/world_position", global_position)
	grass_particles.process_material.set("shader_parameter/amount", amount_of_grass)
	grass_particles.process_material.set("shader_parameter/sway", sway)
	grass_particles.process_material.set("shader_parameter/speed", speed)
	grass_particles.process_material.set("shader_parameter/phase_difference", phase_difference)
	grass_particles.amount = amount_of_grass
	grass_particles.visibility_rect.position = -size/2
	grass_particles.visibility_rect.size = size
	
	if node != null:
		if (circles.size() < 1):
			circles.append(Circle.create(node.global_position, 50.0))
		circles[circles.size() - 1].position = node.global_position
		#var working_image := Image.create_empty(noise_texture.get_size().x,noise_texture.get_size().y,false,Image.FORMAT_RGBA8)
		#working_image.fill(Color(0.0, 0.0, 0.0, 1.0))
		#var circle_center = (node.global_position + size / 2)/size
		#var radius = 0.07
		#for x in noise_texture.get_size().x:
			#for y in noise_texture.get_size().y:
				#var new_color:Color = Color()
				#var uv:Vector2 = Vector2((x+0.5)/noise_texture.get_size().x, (y+0.5)/noise_texture.get_size().y)
				#var dist = sqrt(pow(uv.x - circle_center.x, 2) + pow(uv.y - circle_center.y, 2))
				#if(dist < radius):
					#new_color = Color(1-dist*10, 1-dist*10, 1-dist*10, 1)
				#working_image.set_pixel(x,y,new_color)
		#height_map.update(working_image)
	pass
