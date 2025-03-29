extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_collision_shape: CollisionShape2D = $Area2D/CollisionShape2D2
@onready var clang_1: AudioStreamPlayer2D = $"Sounds/Clang 1"
@onready var clang_2: AudioStreamPlayer2D = $"Sounds/Clang 2"

#shaders
const BLUE_RED_SCREEN_BALL_SHADER = preload("res://Shaders/Ball Shaders/blue red screen ball shader.gdshader")
const GREEN_BLUE_SCREEN_BALL_SHADER = preload("res://Shaders/Ball Shaders/green blue screen ball shader.gdshader")
const GREEN_RED_SCREEN_BALL_SHADER = preload("res://Shaders/Ball Shaders/green red screen ball shader.gdshader")

@export var color: Color = Color(1,1,1)
@export var push_force: float = 10000
@export var min_size: float = 10
@export var max_size: float = 50
@export_range(0,1) var drag_strength: float = 0.5
var ball_input_size: float = 10

var is_inside_window_edges: bool = false

#mouse bools
var hovering_on_ball:bool = false
var dragging_ball:bool = false


func _ready() -> void:
	var circle_collision:CircleShape2D = CircleShape2D.new()
	# if ball too small, do the default ball size if 10
	if (ball_input_size < 10):
		return
	else: circle_collision.radius = ball_input_size
	
	
	collision_shape.shape = circle_collision
	area_collision_shape.shape = collision_shape.shape
	mass = circle_collision.radius/min_size
	
	
	var shaders = [
		BLUE_RED_SCREEN_BALL_SHADER,
		GREEN_BLUE_SCREEN_BALL_SHADER,
		GREEN_RED_SCREEN_BALL_SHADER
		]
	if sprite.material:
		#the 10.0 is because the sprite circle has a diameter of 10 pixels
		sprite.material.set("shader_parameter/cirlce_size", 
						collision_shape.shape.radius/10.0);
		sprite.material.shader = shaders.pick_random()

func _physics_process(_delta: float) -> void:
	screen_bounce()
	drag()

func screen_bounce():
# when the ball reaches either end of screen, flip their velocity, and play sound
# Also, ball won't ever leave the window thanks to clamping the position

	var radius = collision_shape.shape.radius
	var window_edge = get_viewport_rect().size
	var gpos = global_position
	
	#clamp forces the ball to teleport to window edge when outside it
	position.x = clamp(gpos.x, radius ,window_edge.x-radius)
	position.y = clamp(gpos.y, radius ,window_edge.y-radius)
	#This checks if the ball is outside/touching the window edge
		#It takes acount the ball's size/radius into account
	if gpos.x - radius <= 0 or gpos.x + radius >= window_edge.x:
		linear_velocity.x *= -1  # Reverse X velocity
		if not dragging_ball and not is_inside_window_edges:
			play_rand_ball_sound()
			is_inside_window_edges = true
	#This checks if the ball is outside/touching the window edge
		#It takes acount the ball's size/radius into account
	elif gpos.y - radius <= 0 or gpos.y + radius >= window_edge.y:
		linear_velocity.y *= -1  # Reverse Y velocity
		if not dragging_ball and not is_inside_window_edges:
			play_rand_ball_sound()
			is_inside_window_edges = true
	else: is_inside_window_edges = false
func drag():
	#right click for drag
	#if mouse is over the ball and you right clicked, then start dragging
	if hovering_on_ball and Input.is_action_just_pressed("Right Mouse Button"):
		dragging_ball = true
	# stop dragging the ball when released the right mouse button
	if Input.is_action_just_released("Right Mouse Button"):
		dragging_ball = false
	#if you are draging and left clicked, delete currently dragged ball
	if dragging_ball and Input.is_action_just_pressed("Mouse_Press"):
		queue_free()
	
	#Drags the ball to the mouse position smoothly
	if dragging_ball:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		apply_force(direction * 1000 * Vector2(global_position).distance_to(mouse_pos))
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, drag_strength)

func play_rand_ball_sound():
	var sounds = BallSounds
	
	#picking a random sound from the sound node
	var rng = randi_range(0,sounds.get_child_count()-1)
	sounds.get_child(rng).pitch_scale = randf_range(0.95,1.4)
	sounds.get_child(rng).play()

func _on_area_2d_mouse_entered() -> void:
	hovering_on_ball = true

func _on_area_2d_mouse_exited() -> void:
	hovering_on_ball = false

func _on_body_entered(_body: Node) -> void:
	play_rand_ball_sound()
