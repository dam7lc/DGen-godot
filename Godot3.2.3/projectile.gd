extends RigidBody
const speed = 100.0
var k_collision
var playerid
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	playerid = get_parent().get_node("Player").get_instance_id()
	global_scale(Vector3(.5,.5,.5))
	apply_impulse(Vector3.ZERO,-get_transform().basis.z * speed)
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered", self, "hit")

func hit(body):
	print("funciona!")
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()
	


