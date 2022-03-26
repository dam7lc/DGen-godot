extends RigidBody
const speed = 100.0
var k_collision
var playerid

func _ready():
	playerid = get_parent().get_node("Player").get_instance_id()
	global_scale(Vector3(.5,.5,.5))
	apply_impulse(Vector3.ZERO,-get_transform().basis.z * speed)
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered", self, "hit")

func hit(body):
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()
	


