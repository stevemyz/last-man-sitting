extends KinematicBody

const movement_speed = 0.5
const velocity_limit = 5
const acceleration = 0.2
const gravity = 5
const friction = 0.7

const shoot_interval = 0.1
var shoot_cooldown = 0

var velocity = Vector3()
var is_shooting = false

const Bullet = preload("res://Bullet/Bullet.tscn")

func _get_joystick_direction():
	return $"/root/Level/Joystick/JoystickKnob".joystick_direction
	
func _try_shoot(delta):
	var has_shot = shoot_cooldown <= 0
	if has_shot:
		shoot_cooldown += shoot_interval
		var bullet = Bullet.instance()
		bullet.transform.origin = transform.origin + transform.basis.z * 2.2
		bullet.rotation = rotation
		$"/root/Level".add_child(bullet)
	shoot_cooldown -= delta
	return has_shot
			
func _rotate_body():
	var direction = _get_joystick_direction()
	if direction != Vector2():
		rotation.y = -direction.angle()

func _process(delta):
	_rotate_body()

func _physics_process(delta):
	if is_shooting:
		var has_shot = _try_shoot(delta)
		var direction = Vector3()
		var joystick_direction = _get_joystick_direction()
		
		direction.x += joystick_direction.y
		direction.z -= joystick_direction.x
		
		if has_shot:
			velocity += direction * movement_speed
	else:
		velocity = velocity * pow((1 - friction), delta)
		shoot_cooldown = 0
	velocity.y = -gravity
	velocity = move_and_slide(velocity)
