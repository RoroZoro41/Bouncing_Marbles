extends Node2D
const BALL = preload("res://Ball.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_Press") :
		var ball: RigidBody2D = BALL.instantiate()
		ball.position = get_global_mouse_position()
		get_parent().add_child(ball)
