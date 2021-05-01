extends KinematicBody

var direction: Vector3 = Vector3.FORWARD
var movement_speed: float
var velocity: Vector3 = Vector3.ZERO
var acceleration: float = 10
var vertical_velocity: float = 0
var gravity: float = 20
var last_dash_time = 0
var can_dash = true
var array_paredes_a_ignorar: Array
var springArm: SpringArm
var camera: Camera
var player_mesh: Spatial
var space_state: PhysicsDirectSpaceState
var mouse_at_x: float
var mouse_at_z: float

func _ready():
	player_mesh = $Mesh
	camera = $SpringArm/Camera
	springArm = $SpringArm
	springArm.add_excluded_object(.get_rid())
	array_paredes_a_ignorar = Array()
	
func _input(event):
	if event is InputEventMouseMotion:
		var from: Vector3 = camera.project_ray_origin(event.position)
		var to: Vector3 = from + camera.project_ray_normal(event.position) * 5000 	
		
		if(space_state):
			var ignore = Array()
			ignore.append(self)
			var result = space_state.intersect_ray(from, to, ignore, 0x7FFFFFFF, true, true)
			if(result):
				mouse_at_x = result.position.x
				mouse_at_z = result.position.z
				player_mesh.look_at(Vector3(result.position.x, -.815, result.position.z), Vector3(0,1,0))

func _physics_process(delta):
	
	direction = Vector3(Input.get_action_strength("strafe_right")-Input.get_action_strength("strafe_left"),
						0,
						Input.get_action_strength("backward")-Input.get_action_strength("forward")).normalized() 
						
	if Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("strafe_left") || Input.is_action_pressed("strafe_right"):
		movement_speed = 8
	else:
		movement_speed = 0
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)	
						
	move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
		
	space_state = get_world().direct_space_state
	
	if Input.is_action_just_pressed("dash"):
		var actual_time = OS.get_ticks_msec()
		if (actual_time-last_dash_time) > 1000:
			can_dash = true
		if can_dash:
			$AnimationTree.set("parameters/OneShot/active", true)
			last_dash_time = OS.get_ticks_msec()
			can_dash = false
	
	var mouse = Vector2(mouse_at_x, mouse_at_z).normalized()
	var rotation = -(Vector2(0,-1).angle_to(mouse))
	var anim_value = (Vector2(direction.x, direction.z).rotated(rotation)*Vector2(1,-1))
	
	
	$AnimationTree.set("parameters/Direction/blend_position", anim_value)
	
func agregar_pared_a_ignorar(pared):
	array_paredes_a_ignorar.append(pared)

func generacion_finalizada():
	for pared in array_paredes_a_ignorar:
		springArm.add_excluded_object(pared)
