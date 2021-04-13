extends StaticBody

var shootTime = 2.0
var prevShootTime = 0
var actualTime = 0
var unit_mesh

func _ready():
	unit_mesh = load("res://Imports/Unit.obj")

func _process(delta):
	actualTime+=delta
	look_at(get_parent().get_node("Player").get_translation(), Vector3(0,1,0))
	if actualTime-prevShootTime >= shootTime:
		shoot()
		prevShootTime = actualTime
	
	
func shoot():
	var projectile = RigidBody.new()
	var projectileMesh = MeshInstance.new()
	projectileMesh.set_mesh(unit_mesh)
	var projectileCollision = CollisionShape.new()
	projectileCollision.set_shape(BoxShape.new())
	projectileCollision.set_scale(Vector3(.5,.5,.5))
	projectile.add_child(projectileMesh)
	projectile.add_child(projectileCollision)
	projectile.set_script(load("res://Scripts/projectile.gd"))
	projectile.set_scale(Vector3(.4,.4,.4))
	projectile.set_rotation(get_rotation())
	projectile.set_translation(get_translation()+(-get_transform().basis.z*2))
	
	get_parent().add_child(projectile)
	
	
