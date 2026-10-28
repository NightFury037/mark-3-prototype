extends Node3D

var player
var enemy
var status_label: Label
var health_label: Label
var xp_label: Label
var enemy_health := 100.0
var player_health := 100.0
var xp := 0
var attack_cooldown := 0.0
var world_root: Node3D

func _ready() -> void:
    _make_environment()
    _make_world()
    _make_player()
    _make_enemy()
    _make_hud()

func _process(delta: float) -> void:
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
    if player and enemy and is_instance_valid(enemy):
        var distance = player.global_position.distance_to(enemy.global_position)
        if distance < 2.3 and attack_cooldown <= 0.0:
            player_health = maxf(0.0, player_health - 4.0 * delta)
            _update_hud()
        if player_health <= 0.0:
            status_label.text = "Arjun is exhausted! Tap RESTART to try again."
    if enemy_health <= 0.0 and enemy and is_instance_valid(enemy):
        enemy.queue_free()
        enemy = null
        xp += 100
        status_label.text = "BOSS DEFEATED! +100 XP — Prototype complete."
        _update_hud()

func _make_environment() -> void:
    var env = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_SKY
    environment.sky = Sky.new()
    environment.sky.sky_material = ProceduralSkyMaterial.new()
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.74, 0.79, 0.88)
    environment.ambient_light_energy = 0.8
    env.environment = environment
    add_child(env)
    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -30, 0)
    sun.light_energy = 1.15
    add_child(sun)

func _mat(color: Color) -> StandardMaterial3D:
    var m = StandardMaterial3D.new()
    m.albedo_color = color
    return m

func _box(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
    var mesh = BoxMesh.new()
    mesh.size = size
    var inst = MeshInstance3D.new()
    inst.mesh = mesh
    inst.position = pos
    inst.material_override = _mat(color)
    parent.add_child(inst)
    return inst

func _make_world() -> void:
    _box(self, Vector3(0, -0.35, 0), Vector3(70, 0.6, 70), Color(0.48, 0.55, 0.28))
    # Dirt village path
    _box(self, Vector3(0, -0.02, 0), Vector3(7, 0.08, 48), Color(0.58, 0.43, 0.27))
    # Field strips
    for i in range(5):
        _box(self, Vector3(-20 + i * 8, -0.01, -15), Vector3(5, 0.04, 24), Color(0.35 + i * 0.025, 0.48, 0.20))
    # Mud houses with terracotta roofs
    _house(Vector3(-10, 0, -5), Color(0.68, 0.48, 0.31))
    _house(Vector3(11, 0, -12), Color(0.75, 0.57, 0.38))
    _house(Vector3(-12, 0, 12), Color(0.63, 0.43, 0.29))
    # Well
    var well = CSGCylinder3D.new()
    well.radius = 1.1
    well.height = 0.7
    well.position = Vector3(7, 0.35, 6)
    well.material = _mat(Color(0.47, 0.47, 0.43))
    add_child(well)
    var water = CSGCylinder3D.new()
    water.radius = 0.78
    water.height = 0.08
    water.position = Vector3(7, 0.7, 6)
    water.material = _mat(Color(0.18, 0.42, 0.56))
    add_child(water)
    # Stylised trees
    for p in [Vector3(-23,0,-20), Vector3(-21,0,8), Vector3(22,0,15), Vector3(22,0,-20), Vector3(-5,0,23), Vector3(17,0,25)]:
        var trunk = CSGCylinder3D.new()
        trunk.radius = 0.25
        trunk.height = 2.0
        trunk.position = p + Vector3(0,1,0)
        trunk.material = _mat(Color(0.34,0.20,0.10))
        add_child(trunk)
        var crown = CSGSphere3D.new()
        crown.radius = 1.25
        crown.position = p + Vector3(0,2.7,0)
        crown.material = _mat(Color(0.18,0.39,0.17))
        add_child(crown)

func _house(pos: Vector3, wall_color: Color) -> void:
    _box(self, pos + Vector3(0,1.2,0), Vector3(5.0,2.4,4.0), wall_color)
    _box(self, pos + Vector3(0,2.65,0), Vector3(5.7,0.5,4.7), Color(0.48,0.20,0.12))
    _box(self, pos + Vector3(0,0.9,2.02), Vector3(0.9,1.8,0.08), Color(0.20,0.12,0.08))

func _make_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Arjun"
    player.position = Vector3(0, 0.2, 7)
    player.set_script(load("res://player.gd"))
    add_child(player)

func _make_enemy() -> void:
    enemy = CharacterBody3D.new()
    enemy.name = "Village_Boss"
    enemy.position = Vector3(0, 0.2, -7)
    enemy.set_script(load("res://enemy.gd"))
    add_child(enemy)

func damage_enemy(amount: float) -> void:
    if enemy and is_instance_valid(enemy):
        enemy_health = maxf(0.0, enemy_health - amount)
        if enemy.has_method("take_hit"):
            enemy.take_hit()
        _update_hud()

func _make_hud() -> void:
    var layer = CanvasLayer.new()
    add_child(layer)
    var panel = PanelContainer.new()
    panel.position = Vector2(16, 16)
    panel.size = Vector2(370, 142)
    layer.add_child(panel)
    var vb = VBoxContainer.new()
    panel.add_child(vb)
    var title = Label.new()
    title.text = "MARK 3  |  RISE OF THE OUTCAST"
    title.add_theme_font_size_override("font_size", 20)
    vb.add_child(title)
    health_label = Label.new()
    vb.add_child(health_label)
    xp_label = Label.new()
    vb.add_child(xp_label)
    status_label = Label.new()
    status_label.text = "MISSION 01: Training Ground — defeat the village boss."
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vb.add_child(status_label)
    # Touch controls on the lower corners.
    _touch_button(layer, "▲", Vector2(105, 500), "move_forward")
    _touch_button(layer, "▼", Vector2(105, 610), "move_back")
    _touch_button(layer, "◀", Vector2(30, 555), "move_left")
    _touch_button(layer, "▶", Vector2(180, 555), "move_right")
    var attack_btn = Button.new()
    attack_btn.text = "PUNCH"
    attack_btn.position = Vector2(1030, 555)
    attack_btn.size = Vector2(190, 100)
    attack_btn.add_theme_font_size_override("font_size", 24)
    layer.add_child(attack_btn)
    attack_btn.pressed.connect(_attack)
    var restart_btn = Button.new()
    restart_btn.text = "RESTART"
    restart_btn.position = Vector2(1060, 16)
    restart_btn.size = Vector2(150, 48)
    layer.add_child(restart_btn)
    restart_btn.pressed.connect(_restart)
    _update_hud()

func _touch_button(layer: CanvasLayer, label: String, pos: Vector2, action: String) -> void:
    var b = Button.new()
    b.text = label
    b.position = pos
    b.size = Vector2(68, 68)
    b.add_theme_font_size_override("font_size", 25)
    layer.add_child(b)
    b.button_down.connect(func(): Input.action_press(action))
    b.button_up.connect(func(): Input.action_release(action))
    b.tree_exiting.connect(func(): Input.action_release(action))

func _attack() -> void:
    if attack_cooldown > 0.0 or not enemy or not is_instance_valid(enemy):
        return
    attack_cooldown = 0.55
    if player.global_position.distance_to(enemy.global_position) < 3.3:
        damage_enemy(20.0)
        status_label.text = "Good hit! Keep attacking and watch your health."
    else:
        status_label.text = "Move closer to the boss before punching."

func _restart() -> void:
    get_tree().reload_current_scene()

func _update_hud() -> void:
    if is_instance_valid(health_label):
        health_label.text = "ARJUN HEALTH: %d / 100" % int(player_health)
        xp_label.text = "XP: %d     BOSS HEALTH: %d / 100" % [xp, int(enemy_health)]
