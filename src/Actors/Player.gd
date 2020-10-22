extends Actor

export var stomp_impulse = 1000.0

func _physics_process(delta: float) -> void:
	var is_jump_interrumped: = Input.is_action_just_pressed("jump") and _velocity.y < 0.0
	var direction = _get_direction()
	_velocity = _calculate_move_velocity(_velocity, direction, speed, is_jump_interrumped)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	return

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = _calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()
	


func _get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
	)

func _calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrumped: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrumped:
		 out.y = 0.0
	return out

func _calculate_stomp_velocity(
	linear_velocity: Vector2,
	impulse: float
) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	return out

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
