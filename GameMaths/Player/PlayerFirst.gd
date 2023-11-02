extends CharacterBody2D
class_name CharacterFirst

@export var moveSpeed : float = 300.0

var gravity : float = 980.0
var direction : float

func _input(event) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta):
	#sets wanted input direction and intensity
	direction = Input.get_axis("MoveLeft", "MoveRight") * moveSpeed

func _physics_process(delta) -> void:
	
	apply_gravity(delta)
	
	velocity.x = direction
	
	move_and_slide()

func apply_gravity(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

