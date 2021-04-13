extends Spatial

const cuantos = 6
var room_center = Vector2(0,0)
var floor_collision
var room_x
var prev_room_x = 0
var room_z
var prev_room_z = 0
const room_y = 1.5
var player
var surface_material

var array_quad_vertices = [];
var array_quad_indices = [];

var dictionary_check_quad_vertices = {};

const CUBE_SIZE = 1;


#Llamado cuando se inicializa el objeto
func _ready():
	
	for child in get_parent().get_children(): #Obtener referencia al player para ignorar colision de la camara con paredes
		if child.get_script() == load("res://Scripts/Player.gd"):
			player = child
	
	surface_material = load("res://Materials/base_spatial_material.tres")
	
	for j in range(cuantos): #For para cada habitacion
		
		#Randomizar tamaño habitacion
		randomize()
		room_x = rand_range(5,10)
		randomize()
		room_z = rand_range(5,10)
		
		if j != 0:
			room_center.x = room_center.x + (room_x) 	
			#room_center.y = room_center.x + (room_z/2)
		
		
		var paredes = Array()
		
		#Se crean los tipos de objeto para 4 paredes y 1 piso
		for i in range(5): #for para cada pared y piso
			
			paredes.append(StaticBody.new())
			var pared_colision = CollisionShape.new()
			var colshape = BoxShape.new()
			colshape.set_extents(Vector3(1,1,1))
			pared_colision.set_shape(colshape)
			paredes[i].add_child(pared_colision)
			
			if i == 3: #Si es la pared de abajo generar una colision en area adicional
				var area_col = Area.new()
				var paredes_colisiones2 = CollisionShape.new()
				var colshape2 = BoxShape.new()
				colshape2.set_extents(Vector3(1,1,1))
				paredes_colisiones2.set_shape(colshape2)
				area_col.add_child(paredes_colisiones2)
				paredes[i].add_child(area_col)
				paredes[i].set_script(load("res://Scripts/Area_pared_inferior.gd"))
				paredes[i].area_added()
					
			
			var pared_mesh = make_cube()
			pared_mesh.set_surface_material(0,surface_material)
			paredes[i].add_child(pared_mesh)	
			if paredes[i].get_script() == load("res://Scripts/Area_pared_inferior.gd"):
				paredes[i].mesh_added()
			add_child(paredes[i])
			
		#Si la habitacion es mas pequeña generar paredes adicionales
		
		if room_z < prev_room_z : 
			var dif = prev_room_z - room_z
			var pared = StaticBody.new()
			var pared_colision = CollisionShape.new()
			var pared_mesh = make_cube()
			pared_mesh.set_surface_material(0,surface_material)
			pared.add_child(pared_mesh)
			var colshape = BoxShape.new()
			colshape.set_extents(Vector3(1,1,1))
			pared_colision.set_shape(colshape)
			pared.add_child(pared_colision)
			paredes.append(pared)
			pared.set_scale(Vector3(.1,room_y,dif/2))
			pared.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y+room_z+dif/2)))
			add_child(pared)
			
			
			var pared2 = StaticBody.new()
			var pared_colision2 = CollisionShape.new()
			var pared_mesh2 = make_cube()
			pared_mesh2.set_surface_material(0,surface_material)
			pared2.add_child(pared_mesh2)
			var colshape2 = BoxShape.new()
			colshape2.set_extents(Vector3(1,1,1))
			pared_colision2.set_shape(colshape2)
			pared2.add_child(pared_colision2)
			paredes.append(pared2)
			pared2.set_scale(Vector3(.1,room_y,dif/2))
			pared2.global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z-dif/2)))
			add_child(pared2)
		
		#Tamaño de pared0(pared de arriba)
		#Tamaño del mesh
		paredes[0].get_child(1).scale.x = room_x
		paredes[0].get_child(1).scale.y = room_y
		paredes[0].get_child(1).scale.z = .1
		#Tamaño de la colision
		paredes[0].get_child(0).scale.x = room_x
		paredes[0].get_child(0).scale.y = room_y
		paredes[0].get_child(0).scale.z = .1
		#Posicion pared0
		paredes[0].global_translate(Vector3(room_center.x,room_y,(-room_z)+room_center.y))
		
		#player ignore paredes
		player.agregar_pared_a_ignorar(paredes[0])
		
		if j != 0: #La primer pared debe ser completa (no entrada)
			
			#Tamaño de pared1(pared de la izquierda)
			#Tamaño del mesh
			paredes[1].get_child(1).scale.z = room_z/3
			paredes[1].get_child(1).scale.y = room_y
			paredes[1].get_child(1).scale.x = .1
			#Tamaño de Collision
			paredes[1].get_child(0).scale.x = .1
			paredes[1].get_child(0).scale.z = room_z/3
			paredes[1].get_child(0).scale.y = room_y
			#Posicion pared1
			paredes[1].global_translate(Vector3((-room_x)+room_center.x,room_y,(room_center.y-room_z/1.5)))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[1])
			
			#Tamaño de pared2(pared de la izquierda 2)
			#Tamaño del mesh
			paredes[2].get_child(1).scale.z = room_z/3
			paredes[2].get_child(1).scale.y = room_y
			paredes[2].get_child(1).scale.x = .1
			#Tamaño de Collision
			paredes[2].get_child(0).scale.z = room_z/3
			paredes[2].get_child(0).scale.y = room_y
			paredes[2].get_child(0).scale.x = .1
			#Posicion pared2
			paredes[2].global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y+room_z/1.5))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[2])
			
		else:
			paredes[1].get_child(1).scale.z = room_z
			paredes[1].get_child(1).scale.y = room_y
			paredes[1].get_child(1).scale.x = .1
			
			paredes[1].get_child(0).scale.z = room_z
			paredes[1].get_child(0).scale.x = .1
			paredes[1].get_child(0).scale.y = room_y
			
			paredes[1].global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[1])
			
			paredes[2].get_child(1).scale.z = 0
			paredes[2].get_child(1).scale.y = 0
			
			paredes[2].get_child(0).scale.z = 0
			paredes[2].get_child(0).scale.x = 0
			paredes[2].get_child(0).scale.y = 0
			
			paredes[2].global_translate(Vector3((-room_x)+room_center.x,room_y,room_center.y+room_z/3))
			#player ignore paredes
			player.agregar_pared_a_ignorar(paredes[2])
		
		#Tamaño de pared3(pared de abajo)
		paredes[3].get_child(2).scale.x = room_x
		paredes[3].get_child(2).scale.y = room_y
		paredes[3].get_child(2).scale.z = .1
		#Tamaño de colision
		paredes[3].get_child(0).scale.x = room_x
		paredes[3].get_child(0).scale.y = room_y
		paredes[3].get_child(0).scale.z = .1
		
		paredes[3].get_child(1).scale.x = room_x
		paredes[3].get_child(1).scale.y = .5
		paredes[3].get_child(1).scale.z = 1
		paredes[3].get_child(1).translate_object_local(Vector3(0.0,-2,-1))
		#Posicion pared 3
		paredes[3].global_translate(Vector3(room_center.x,room_y,(room_z)+room_center.y))
		player.agregar_pared_a_ignorar(paredes[3])
		
		
		#Tamaño del piso
		paredes[4].get_child(1).scale.x = room_x
		paredes[4].get_child(1).scale.y = .2
		paredes[4].get_child(1).scale.z = room_z 
		#Tamaño de Colision
		paredes[4].get_child(0).scale.x = room_x
		paredes[4].get_child(0).scale.y = .2
		paredes[4].get_child(0).scale.z = room_z
		#Posicion piso
		paredes[4].global_translate(Vector3(room_center.x,0,room_center.y))
		
		room_center.x = room_center.x + room_x
		prev_room_x = room_x 
		prev_room_z = room_z
		
		
		
	player.generacion_finalizada()
		
	

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

	