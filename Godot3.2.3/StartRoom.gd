extends StaticBody

var floor_collision
var room_x
var room_z
var paredes = Array()
var paredes_colisiones = Array()
var paredes_meshes = Array()
#var unit_mesh
var surface_material

var array_quad_vertices = [];
var array_quad_indices = [];

var dictionary_check_quad_vertices = {};

const CUBE_SIZE = .5;


# Called when the node enters the scene tree for the first time.
func _ready():
	floor_collision = $CollisionShape
	#unit_mesh = load("res://Unit.obj")
	surface_material = load("res://base_spatial_material.tres")
	#Set floor size
	randomize()
	room_x = rand_range(10,30)
	randomize()
	room_z = rand_range(10,30)
	floor_collision.scale.x = room_x/2
	floor_collision.scale.z = room_z/2
		
	#new TESTmesh
	var testMesh = make_cube()
#	testMesh.translate(Vector3(-room_x/2, .5,-room_z/2))
	testMesh.scale.x = room_x
	testMesh.scale.z = room_z
	add_child(testMesh)
	
	
	
		#Create Walls
	for i in range(4):
		paredes.append(StaticBody.new())
		paredes_colisiones.append(CollisionShape.new())
		var colshape = BoxShape.new()
		colshape.set_extents(Vector3(1,1,1))
		paredes_colisiones[i].set_shape(colshape)
		paredes[i].add_child(paredes_colisiones[i])	
		add_child(paredes[i])
		paredes_meshes.append(make_cube())
#		paredes_meshes[i].set_mesh(unit_mesh)
#		paredes_meshes[i].set_surface_material(0,surface_material)
		paredes[i].add_child(paredes_meshes[i])	
			
			
			
	#Transform wall0(up)
	#Transform mesh
	paredes[0].get_child(1).scale.x = room_x
	paredes[0].get_child(1).scale.y = 5
	#Transform Collision
	paredes[0].get_child(0).scale.x = room_x/2
	paredes[0].get_child(0).scale.y = 5
	#move wall0
	paredes[0].global_translate(Vector3(0,2.5,-room_z/2))
	
	#Transform wall1(left)
	#Transform mesh
	paredes[1].get_child(1).scale.z = room_z
	paredes[1].get_child(1).scale.y = 5.0
	#Transform Collision
	paredes[1].get_child(0).scale.z = room_z/2
	paredes[1].get_child(0).scale.y = 5
	#Move wall 1
	paredes[1].global_translate(Vector3(-room_x/2,2.5,0))
	
	#Transform wall2(right)
	#Transform mesh
	paredes[2].get_child(1).scale.z = room_z
	paredes[2].get_child(1).scale.y = 5.0
	#Transform Collision
	paredes[2].get_child(0).scale.z = room_z/2
	paredes[2].get_child(0).scale.y = 5
	#Move wall 2
	paredes[2].global_translate(Vector3(room_x/2,2.5,0))
	
	#Transform wall3(down) 
	paredes[3].get_child(1).scale.x = room_x
	paredes[3].get_child(1).scale.y = 5
	#Transform Collision
	paredes[3].get_child(0).scale.x = room_x/2
	paredes[3].get_child(0).scale.y = 5
	#Move wall 2
	paredes[3].global_translate(Vector3(0,2.5,room_z/2))
	
	#TODO register ignore to springarm
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func newMesh():
#	var tmpMesh = Mesh.new()
#	var vertices = PoolVector3Array()
#	var UVs = PoolVector2Array()
#	var mat = SpatialMaterial.new()
#	var color = Color(0.9, 0.1, 0.1)
#	var testMesh = MeshInstance.new()

func make_cube():
	array_quad_vertices = [];
	array_quad_indices = [];
	dictionary_check_quad_vertices = {};
	
	var result_mesh = Mesh.new();
	var testMesh = MeshInstance.new()
	var surface_tool = SurfaceTool.new();
	
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var vert_north_topright = Vector3(-CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
	var vert_north_topleft = Vector3(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
	var vert_north_bottomleft = Vector3(CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE);
	var vert_north_bottomright = Vector3(-CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE);
	
	var vert_south_topright = Vector3(-CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE);
	var vert_south_topleft = Vector3(CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE);
	var vert_south_bottomleft = Vector3(CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE);
	var vert_south_bottomright = Vector3(-CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE);
	
	
	# Make the six quads for needed to make a box!
	# ============================================
	# IMPORTANT: You have to input the points in the going either clockwise, or counter clockwise
	# or the add_quad function will not work!
	
	add_quad(vert_south_topright, vert_south_topleft, vert_south_bottomleft, vert_south_bottomright);
	add_quad(vert_north_topright, vert_north_bottomright, vert_north_bottomleft, vert_north_topleft);
	
	add_quad(vert_north_bottomleft, vert_north_bottomright, vert_south_bottomright, vert_south_bottomleft);
	add_quad(vert_north_topleft, vert_south_topleft, vert_south_topright, vert_north_topright);
	
	add_quad(vert_north_topright, vert_south_topright, vert_south_bottomright, vert_north_bottomright);
	add_quad(vert_north_topleft, vert_north_bottomleft, vert_south_bottomleft, vert_south_topleft);
	# ============================================
	
	for vertex in array_quad_vertices:
		surface_tool.add_vertex(vertex);
	for index in array_quad_indices:
		surface_tool.add_index(index);
	
	surface_tool.generate_normals();
	
	result_mesh = surface_tool.commit();
	testMesh.set_mesh(result_mesh)
	return testMesh


func add_quad(point_1, point_2, point_3, point_4):
	
	var vertex_index_one = -1;
	var vertex_index_two = -1;
	var vertex_index_three = -1;
	var vertex_index_four = -1;
	
	vertex_index_one = _add_or_get_vertex_from_array(point_1);
	vertex_index_two = _add_or_get_vertex_from_array(point_2);
	vertex_index_three = _add_or_get_vertex_from_array(point_3);
	vertex_index_four = _add_or_get_vertex_from_array(point_4);
	
	array_quad_indices.append(vertex_index_one)
	array_quad_indices.append(vertex_index_two)
	array_quad_indices.append(vertex_index_three)
	
	array_quad_indices.append(vertex_index_one)
	array_quad_indices.append(vertex_index_three)
	array_quad_indices.append(vertex_index_four)


func _add_or_get_vertex_from_array(vertex):
	if dictionary_check_quad_vertices.has(vertex) == true:
		return dictionary_check_quad_vertices[vertex];
	
	else:
		array_quad_vertices.append(vertex);
		
		dictionary_check_quad_vertices[vertex] = array_quad_vertices.size()-1;
		return array_quad_vertices.size()-1;

	
