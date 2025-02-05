extends Node2D
const BALL = preload("res://Scenes/Ball.tscn")
const BALL_WITH_SPRITE = preload("res://Scenes/ball_with_sprite.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button"):
		#var ball: RigidBody2D = BALL.instantiate()
		var ball: RigidBody2D = BALL_WITH_SPRITE.instantiate()
		ball.position = get_global_mouse_position()
		get_parent().add_child(ball)
	
	#if Input.is_action_pressed("Mouse_Press") and not Input.is_action_pressed("Right Mouse Button"):
		#var ball: RigidBody2D = BALL.instantiate()
		#ball.collision_shape.shape.radius = 10
		#ball.position = get_global_mouse_position()
		#get_parent().add_child(ball)
		#
