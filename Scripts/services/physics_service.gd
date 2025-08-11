class_name PhysicsService

static func cast_circle(node: Node2D, radius: float, position: Vector2) -> Array[Dictionary]:
	var circle = CircleShape2D.new()
	circle.radius = radius
	return cast_shape(node, circle, Transform2D(0, position))

static func cast_shape(node: Node2D, shape: Resource, transform: Transform2D) -> Array[Dictionary]:
	var query = PhysicsShapeQueryParameters2D.new()
	query.transform = Transform2D(0, node.global_position)
	query.shape = shape
	
	var space_state = node.get_world_2d().direct_space_state
	return space_state.intersect_shape(query)
