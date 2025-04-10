extends RigidBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D2
@onready var text: Label = $Label

@export var color: Color = Color(1,1,1)
@export var push_force: float = 10000
@export var min_size: float = 10
@export var max_size: float = 50

#var hover_on_ball:bool = false
var hovering_on_ball:bool = false
var dragging_ball:bool = false


func _ready() -> void:
	color = Color(randf(),randf(),randf())
	var circle_collision:CircleShape2D = CircleShape2D.new()
	circle_collision.radius = randf_range(min_size, max_size)
	collision_shape.shape = circle_collision
	area_collision_shape.shape = collision_shape.shape
	mass = circle_collision.radius/10
	
	apply_force(
		Vector2(
			randf_range(-push_force,push_force),
			randf_range(-push_force,push_force)
			)
		)

func _physics_process(delta: float) -> void:

	#easy but inneficient way to make the balls bounce off of edges of screen
	var window_edge = get_viewport_rect().size
	var gpos = global_position
	var radius = collision_shape.shape.radius
	if gpos.x - radius <= 0 or gpos.x + radius >= window_edge.x:
		linear_velocity.x *= -1  # Reverse X velocity
	if gpos.y - radius <= 0 or gpos.y + radius >= window_edge.y:
		linear_velocity.y *= -1  # Reverse X velocity
	
	# moves the ball to inisde the window if it gets too far
	if gpos.x < 0:
		gpos = 10
	
# code for dragging the ball
	if Input.is_action_just_released("Right Mouse Button"):
		dragging_ball = false
	if hovering_on_ball:
		if Input.is_action_just_pressed("Right Mouse Button"):
			dragging_ball = true
	drag()

func _draw() -> void:
	draw_circle(Vector2.ZERO , collision_shape.shape.radius , color/2)
	draw_circle(Vector2.ZERO , collision_shape.shape.radius/1.2 , color)

func drag():
	if dragging_ball:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		apply_force(direction * 1000 * Vector2(global_position).distance_to(mouse_pos))
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, 0.9)

func _on_area_2d_mouse_entered() -> void:
	hovering_on_ball = true

func _on_area_2d_mouse_exited() -> void:
	hovering_on_ball = false


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not body == self:
		#redraws the color, but similarly to how it was before
		var variation = 0.5  # Adjust how much the color changes (smaller = more similar)
		var new_r = clamp(color.r + randf_range(-variation, variation), 0.0, 1.0)
		var new_g = clamp(color.g + randf_range(-variation, variation), 0.0, 1.0)
		var new_b = clamp(color.b + randf_range(-variation, variation), 0.0, 1.0)    
		color = Color(new_r, new_g, new_b)
		queue_redraw()
