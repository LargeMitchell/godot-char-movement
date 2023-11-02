extends CharacterBody2D
class_name Character


@export_group("Jump")
@export var jumpHeight : float = 100.0
@export var timeToJumpApex : float = 1.0
@export var downwardMovementMultiplier : float = 1.2

@export_group("Horizontal Speed")
@export var maxSpeed : float = 300.0

@export_group("Acceleration")
@export var maxAcceleration : float = 1000.0
@export var maxAirAcceleration : float = 100.0

@export_group("Deceleration")
@export var maxDeceleration : float = 1000.0
@export var maxAirDeceleration : float = 100.0

@export_group("Turn Speed")
@export var maxTurnSpeed : float = 1000.0
@export var maxAirTurnSpeed : float = 100.0


var gravity : float = 980.0
var newGravity : float
var gravScale : float = 1.0
var gravMultiplier : float = 1.0
var direction : float
var isFalling : bool 
var acceleration : float
var deceleration : float
var turnSpeed : float
var speedInterp : float
var jumpActive : bool

func _input(event) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta):
	
	#sets wanted input direction and intensity
	direction = Input.get_axis("MoveLeft", "MoveRight") * maxSpeed
	


func _physics_process(delta) -> void:
	
	jump_check()
	
	apply_gravity(delta)
	
	set_states()
	
	horizontal_movement(delta)
	
	move_and_slide()

func apply_gravity(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravScale
		
		isFalling = true
	else:
		isFalling = false

func jump_check():
	
	#Check if player has jump button pressed and is grounded
	if Input.is_action_pressed("Jump") && is_on_floor():
		jumpActive = true
		jump()
	
	#Sets the jump active variable
	if Input.is_action_just_released("Jump"):
		jumpActive = false
	
	#calculates the required gravity multiplier for the custom jump
	newGravity = (2 * jumpHeight) / (timeToJumpApex * timeToJumpApex) * 10
	gravScale = (newGravity / gravity) * gravMultiplier

func jump() -> void:
	# Handle Jump.
	var jump_force : float = sqrt(2.0 * jumpHeight * (gravity * gravScale)) * -1
	velocity.y = jump_force

func set_states() -> void:
	if isFalling == false:
		acceleration = maxAcceleration
		deceleration = maxDeceleration
		turnSpeed = maxTurnSpeed
	else:
		acceleration = maxAirAcceleration
		deceleration = maxAirDeceleration
		turnSpeed = maxAirTurnSpeed

func horizontal_movement(delta) -> void:
	if direction:
		if sign(direction) != sign(velocity.x):
			speedInterp = turnSpeed * delta
		else:
			speedInterp = acceleration * delta
	else:
		speedInterp = deceleration * delta
	
	velocity.x = move_toward(velocity.x, direction, speedInterp)
	
	pass
