@tool
extends Line2D

@export var radius: float = 100.0
@export var segments: int = 6  # More segments = smoother circle

func _process(_delta: float) -> void:
	var points = []
	for i in range(segments + 1):  # +1 to close the circle
		var angle = (i / float(segments)) * TAU  # TAU = 2 * PI
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
	points.append(points[0])  # Close the loop
	self.points = points
