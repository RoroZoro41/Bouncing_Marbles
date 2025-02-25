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
#@export var sounds: Array[AudioStream] = []

#var hover_on_ball:bool = false
var hovering_on_ball:bool = false
var dragging_ball:bool = false


func _ready() -> void:
	color = Color(randf(),randf(),randf())
	var circle_collision:CircleShape2D = CircleShape2D.new()
	circle_collision.radius = randf_range(min_size, max_size)
	#circle_collision.radius = max_size
	collision_shape.shape = circle_collision
	area_collision_shape.shape = collision_shape.shape
	mass = circle_collision.radius/min_size
	
	var shaders = [
		BLUE_RED_SCREEN_BALL_SHADER,
		GREEN_BLUE_SCREEN_BALL_SHADER,
		GREEN_RED_SCREEN_BALL_SHADER
	]
	if sprite.material:
		sprite.material.set("shader_parameter/marble_color", color)
		#the 10.0 is because the sprite circle has a diameter of 10 pixels
		sprite.material.set("shader_parameter/cirlce_size", 
							collision_shape.shape.radius/10.0);
		sprite.material.shader = shaders.pick_random()
	
	apply_force(Vector2(
					randf_range(-push_force,push_force),
					randf_range(-push_force,push_force)))

func _physics_process(_delta: float) -> void:
	screen_bounce()
	drag()

func screen_bounce():
#easy but inneficient way to make the balls bounce off of edges of screen
	var window_edge = get_viewport_rect().size
	var gpos = global_position
	var radius = collision_shape.shape.radius
	var out_of_bounds_return_offset = 1
	var out_of_bounds_return_dragging_multiplier = 10
	if dragging_ball:
		out_of_bounds_return_dragging_multiplier = 10
	else: out_of_bounds_return_dragging_multiplier = 1
	if gpos.x - radius <= 0 or gpos.x + radius >= window_edge.x:
		linear_velocity.x *= -1  # Reverse X velocity
		if not dragging_ball:
			play_rand_ball_sound()
	
		if gpos.x - radius <= 0:
			position.x += out_of_bounds_return_offset * out_of_bounds_return_dragging_multiplier
		else:
			position.x -= out_of_bounds_return_offset * out_of_bounds_return_dragging_multiplier
	if gpos.y - radius <= 0 or gpos.y + radius >= window_edge.y:
		linear_velocity.y *= -1  # Reverse X velocity
		if not dragging_ball:
			play_rand_ball_sound()
			
		if gpos.y - radius <= 0:
			position.y += out_of_bounds_return_offset * out_of_bounds_return_dragging_multiplier
		else:
			position.y -= out_of_bounds_return_offset * out_of_bounds_return_dragging_multiplier
	# moves the ball to inisde the window if it gets too far
	if gpos.x < 0:
		gpos = 10

func drag():
	#delete currently dragged ball
	if dragging_ball:
		if Input.is_action_just_pressed("Mouse_Press"):
			queue_free()
	# code for dragging the ball
	if Input.is_action_just_released("Right Mouse Button"):
		dragging_ball = false
	if hovering_on_ball:
		if Input.is_action_just_pressed("Right Mouse Button"):
			dragging_ball = true
	if dragging_ball:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		apply_force(direction * 1000 * Vector2(global_position).distance_to(mouse_pos))
		linear_velocity = linear_velocity.lerp(Vector2.ZERO, 0.9)

func play_rand_ball_sound():
	#The sound node2d
	var sounds = $Sounds
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
