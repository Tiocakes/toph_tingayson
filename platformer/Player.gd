extends KinematicBody2D

var health = 100
var StartPosX = 416.165009
var StartPosY = 254.619995
var horizontal_speed = 0
var vertical_speed = 0
var SpeedFlag = true
#var screensize
const ACCELERATION = 800
const GRAVITY = 900 
const DECELLERATION = 700
const JUMP_FORCE = -10
const UP = Vector2(0, -1)


func _ready():
#	screensize = get_viewport_rect().size
	pass

func _input(event):
	if event.is_action_released("ui_up"):
		SpeedFlag = false

func take_damage(damage):
	health -= damage
	health = clamp(health, 0, 100)
	$AnimatedSprite.play("jump")

func death():
	position.x = StartPosX
	position.y = StartPosY
	health = 100

func _process(delta):
	var velocity = Vector2()
	
	# GRAVITY
	vertical_speed += GRAVITY * delta
	velocity.y += 1
	velocity.y = velocity.y * vertical_speed
	
	#TELLING 2DRAYCAST TO IGNORE NOT FLOOR FOR CLIMBING
	if $RayCast2D.is_colliding() && !$RayCast2D.get_collider().is_in_group("Floor"):
		$RayCast2D.add_exception($RayCast2D.get_collider())

	# MOVING RIGHT
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		horizontal_speed += ACCELERATION * delta
		horizontal_speed = clamp(horizontal_speed, 0, 500)
	#DECELERATING RIGHT
	if horizontal_speed > 0 && !(Input.is_action_pressed("ui_right")):
		velocity.x += 1
		horizontal_speed -= DECELLERATION * delta
		if(horizontal_speed < 0):
			velocity.x = 0
	#CLIMBING RIGHT
	if $RayCast2D.is_colliding() && Input.is_action_pressed("ui_right") && $FeetRay.is_colliding():
		position.y -= 6
		position.x += 3
	
	#MOVING LEFT
	if Input.is_action_pressed("ui_left"):
		velocity.x += 1
		horizontal_speed -= ACCELERATION * delta
		horizontal_speed = clamp(horizontal_speed, -500, 0)
	#DECELERATING LEFT
	if horizontal_speed < 0 && !(Input.is_action_pressed("ui_left")):
		velocity.x += 1
		horizontal_speed += DECELLERATION * delta
		if horizontal_speed > 0:
			velocity.x = 0
	#CLIMBING LEFT
	if $RayCast2D.is_colliding() && Input.is_action_pressed("ui_left") && $FeetRay.is_colliding():
		position.y -= 6
		position.x -= 3

	#JUMPING
	if is_on_floor():
		velocity.y = 0
		vertical_speed = 0
		SpeedFlag = true

	if Input.is_action_pressed("ui_up") && SpeedFlag:
		vertical_speed += -1100 * delta
		vertical_speed = clamp(vertical_speed, -800, -500)
		if velocity.y <= -500:
			SpeedFlag = false
			velocity.y = 0
	
	
	#ANIMATIONS
	if $FeetRay.is_colliding():
		if Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right"):
			$AnimatedSprite.play("running")
		else:
			$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("jump")
	
	if (velocity.x != 0):
		$AnimatedSprite.flip_h = horizontal_speed < 0 
		
	if $AnimatedSprite.flip_h:
		$RayCast2D.cast_to.y = -32
	else:
		$RayCast2D.cast_to.y = 32
		
	#CALCULATIONS
	velocity.x = velocity.x * horizontal_speed
	velocity.x = clamp(velocity.x, -500, 500)
	velocity.y = clamp(velocity.y, -700, 500)
	move_and_slide(velocity, UP)
	
	if health == 0:
		death()
	
#	position.x = clamp(position.x, 0, screensize.x)
#	position.y = clamp(position.y, 0, screensize.y)