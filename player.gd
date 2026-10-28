extends CharacterBody3D

var speed := 5.0
var gravity := 18.0
var body_mesh: MeshInstance3D
var camera: Camera3D
var hit_flash := 0.0

func _ready() -> void:
    var capsule = CapsuleMesh.new()
    capsule.radius = 0.42
    capsule.height = 1.7
    body_mesh = MeshInstance3D.new()
    body_mesh.mesh = capsule
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.16, 0.31, 0.68)
    body_mesh.material_override = mat
    body_mesh.position.y = 0.95
    add_child(body_mesh)
    var head = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 0.29
    sphere.height = 0.58
    head.mesh = sphere
    head.position.y = 1.95
    head.material_override = _material(Color(0.72, 0.48, 0.31))
    add_child(head)
    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.radius = 0.42
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)
    camera = Camera3D.new()
    camera.position = Vector3(0, 4.2, 7.5)
    camera.rotation_degrees = Vector3(-22, 0, 0)
    camera.current = true
    add_child(camera)

func _material(color: Color) -> StandardMaterial3D:
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    return m

func _physics_process(delta: float) -> void:
    var direction = Vector3.ZERO
    if Input.is_action_pressed("move_forward"): direction.z -= 1
    if Input.is_action_pressed("move_back"): direction.z += 1
    if Input.is_action_pressed("move_left"): direction.x -= 1
    if Input.is_action_pressed("move_right"): direction.x += 1
    direction = direction.normalized()
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = -0.1
    if direction.length() > 0.1:
        rotation.y = atan2(direction.x, direction.z)
    move_and_slide()
    global_position.x = clampf(global_position.x, -30.0, 30.0)
    global_position.z = clampf(global_position.z, -30.0, 30.0)
