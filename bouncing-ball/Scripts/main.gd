extends Node2D
const BALL = preload("res://Scenes/Ball.tscn")
const BALL_WITH_SPRITE = preload("res://Scenes/ball_with_sprite.tscn")


var mouse_start_position: Vector2 = Vector2(-9999,-9999)
var mouse_end_position: Vector2 = Vector2(-9999,-9999)
var ball_size_creation_multiplier: float = 0.5

func _process(_delta: float) -> void:
	
	#if Input.is_action_just_pressed("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button"):
		#var ball: RigidBody2D = BALL_WITH_SPRITE.instantiate()
		#ball.position = get_global_mouse_position()
		#get_parent().add_child(ball)
	if Input.is_action_just_pressed("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button"):
		mouse_start_position = get_global_mouse_position()
	if Input.is_action_pressed("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button"):
		mouse_end_position = get_global_mouse_position()
	if (Input.is_action_just_released("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button")):
		var ball: RigidBody2D = BALL_WITH_SPRITE.instantiate()
		#ball.position = mouse_start_position
		ball.position.x = clamp(mouse_start_position.x, mouse_drag_distance()/2 + 1, get_viewport_rect().size.x - mouse_drag_distance()/2 - 1)
		ball.position.y = clamp(mouse_start_position.y, mouse_drag_distance()/2 + 1 , get_viewport_rect().size.y - mouse_drag_distance()/2 - 1)

# if circle too small, don't draw it
		ball.ball_input_size = abs(mouse_drag_distance() * ball_size_creation_multiplier)
		add_child(ball)
	
		#resetting the ball creation size
		mouse_start_position = Vector2(-9999,-9999)
		mouse_end_position = Vector2(-9999,-9999)
	
	queue_redraw()
	
func _draw() -> void:
#draw a circle of center of where you first clicked
	# of size of distance from how far you dragged
	draw_circle(
		mouse_start_position, #position
		abs(mouse_drag_distance() * ball_size_creation_multiplier), #radius
		Color.PALE_GREEN, #color
		false,  #isFilled
		5 #line thickness
	)

func mouse_drag_distance() -> float: 
	return mouse_start_position.distance_to(mouse_end_position)


func _on_button_pressed() -> void:
	await get_tree().create_timer(0.01).timeout
	for child in get_children():
		print (child)
		if child is RigidBody2D:
			child.queue_free()
