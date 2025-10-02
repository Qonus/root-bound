@tool
extends MultiMeshInstance2D

func _process(delta: float) -> void:
	for i in multimesh.instance_count:
		var angle = PI
		var pos = Vector2(i * 64, 0)
		multimesh.set_instance_transform_2d(i, Transform2D(angle, pos))
