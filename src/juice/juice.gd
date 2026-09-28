extends CanvasLayer


@export var max_shake_offset := Vector2(90, 70)
@export var shake_decay: float = 2.5
@export var shake_speed: float = 40.0

@export var max_bloom_intensity: float = 1.5

@onready var vignette: ColorRect = $Vignette
@onready var environment: Environment = $WorldEnvironment.environment

var trauma: float = 0.0
var noise := FastNoiseLite.new()
var noise_time: float = 0.0

var is_hit_stopping: bool = false
var vignette_tween: Tween
var bloom_tween: Tween


func _ready() -> void:
	noise.seed = randi()
	noise.frequency = 1.0
	vignette.material.set_shader_parameter("intensity", 0.0)


func _process(delta: float) -> void:
	update_shake(delta)

func shake(amount: float) -> void:
	trauma = minf(trauma + amount, 1.0)

func update_shake(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return

	var real_delta: float = delta / maxf(Engine.time_scale, 0.001)
	trauma = maxf(trauma - shake_decay * real_delta, 0.0)
	noise_time += real_delta * shake_speed

	var power: float = trauma * trauma
	camera.offset = Vector2(
		max_shake_offset.x * power * noise.get_noise_2d(noise_time, 0.0),
		max_shake_offset.y * power * noise.get_noise_2d(0.0, noise_time),
	)


func screen_flash(color: Color = Color.RED, strength: float = 0.6, duration: float = 0.35) -> void:
	vignette.material.set_shader_parameter("flash_color", color)
	vignette.material.set_shader_parameter("intensity", strength)

	if vignette_tween:
		vignette_tween.kill()
	vignette_tween = create_tween().set_ignore_time_scale(true)
	vignette_tween.tween_method(set_vignette_intensity, strength, 0.0, duration) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)


func set_vignette_intensity(value: float) -> void:
	vignette.material.set_shader_parameter("intensity", value)


func hit_stop(duration: float = 0.06, time_scale: float = 0.05) -> void:
	if is_hit_stopping:
		return
	is_hit_stopping = true
	Engine.time_scale = time_scale
	# ignore_time_scale = true so the freeze lasts real seconds
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
	is_hit_stopping = false


func bloom_pulse(amount: float = 0.5, duration: float = 0.3) -> void:
	if bloom_tween:
		bloom_tween.kill()
	environment.glow_intensity = max_bloom_intensity * amount
	environment.glow_bloom = 0.3 * amount
	bloom_tween = create_tween().set_ignore_time_scale(true).set_parallel(true)
	bloom_tween.tween_property(environment, "glow_intensity", 0.0, duration)
	bloom_tween.tween_property(environment, "glow_bloom", 0.0, duration)


func flash_sprite(target: CanvasItem, color: Color = Color(1, 0.3, 0.3), duration: float = 0.12) -> void:
	if not is_instance_valid(target):
		return
	if not target.has_meta("juice_base_modulate"):
		target.set_meta("juice_base_modulate", target.modulate)
	var base: Color = target.get_meta("juice_base_modulate")

	kill_meta_tween(target, "juice_flash_tween")
	target.modulate = color
	var tween := target.create_tween()
	tween.tween_property(target, "modulate", base, duration)
	target.set_meta("juice_flash_tween", tween)


func punch_scale(target: Control, amount: float = 0.25, duration: float = 0.15) -> void:
	if not is_instance_valid(target):
		return

	kill_meta_tween(target, "juice_punch_tween")
	var start_scale := Vector2(1.0 + amount, 1.0 - amount * 0.5)
	set_punch(start_scale, target)
	var tween := target.create_tween()
	tween.tween_method(set_punch.bind(target), start_scale, Vector2.ONE, duration) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	target.set_meta("juice_punch_tween", tween)


func set_punch(value: Vector2, target: Control) -> void:
	if not is_instance_valid(target):
		return
	target.pivot_offset = target.size / 2.0
	target.scale = value


func kill_meta_tween(target: Object, key: String) -> void:
	if target.has_meta(key):
		var old: Tween = target.get_meta(key)
		if old:
			old.kill()


func death_pop(owner_node: Node2D, sprite: Control, grow: float = 1.8, duration: float = 0.25) -> void:
	if not is_instance_valid(owner_node) or not is_instance_valid(sprite):
		return

	var holder := Node2D.new()
	holder.global_position = owner_node.global_position
	holder.z_index = owner_node.z_index
	var copy: Control = sprite.duplicate()
	copy.scale = Vector2.ONE
	copy.modulate = Color(3, 3, 3)
	holder.add_child(copy)
	get_tree().current_scene.add_child(holder)

	var tween := holder.create_tween().set_parallel(true)
	tween.tween_property(holder, "scale", Vector2.ONE * grow, duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(holder, "modulate:a", 0.0, duration)
	tween.chain().tween_callback(holder.queue_free)
