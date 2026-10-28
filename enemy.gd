extends CharacterBody3D

var body: MeshInstance3D
var flash_time := 0.0

func _ready() -> void:
    var capsule = CapsuleMesh.new()
    capsule.radius = 0.55
    capsule.height = 1.9
    body = MeshInstance3D.new()
    body.mesh = capsule
    body.position.y = 1.0
    body.material_override = _mat(Color(0.62, 0.16, 0.12))
    add_child(body)
    var head = MeshInstance3D.new()
    var sphere = SphereMesh.new()
    sphere.radius = 0.33
    sphere.height = 0.66
    head.mesh = sphere
    head.position.y = 2.05
    head.material_override = _mat(Color(0.56, 0.35, 0.24))
    add_child(head)
    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.radius = 0.55
    shape.height = 2.0
    collision.shape = shape
    collision.position.y = 1.0
    add_child(collision)

func _process(delta: float) -> void:
    flash_time = maxf(0.0, flash_time - delta)
    if flash_time <= 0.0 and body:
        body.material_override = _mat(Color(0.62, 0.16, 0.12))

func take_hit() -> void:
    flash_time = 0.12
    if body:
        body.material_override = _mat(Color(1.0, 0.75, 0.2))

func _mat(color: Color) -> StandardMaterial3D:
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    return m
