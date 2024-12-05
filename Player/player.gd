extends CharacterBody3D

@export var health := 100.0
@export var player_max_health := 100.0
@export var running_speed := 10.0
@export var walking_speed := 5.0

@onready var current_speed := walking_speed

@onready var camera: Camera3D = %Camera
@onready var footsteps_timer: Timer = %FootstepsTimer
@onready var audio_hanlder_player: AnimationPlayer = %AudioHanlderPlayer

@onready var footsteps_sfx: AudioStreamPlayer3D = $Footsteps

var footstep_number: int

const FOOTSTEPS_BASE_VOLUME = -35

func _ready() -> void: 
	footsteps_sfx.volume_db = FOOTSTEPS_BASE_VOLUME

func _physics_process(delta: float) -> void:
	# Captures the player input
	handle_movement(delta)
	hold_breath()
	@warning_ignore("return_value_discarded")
	move_and_slide()

func handle_movement(delta: float) -> void:
	# Converts the 2D input to a 3D direction
	var direction := Vector3(get_movement_input().x, 0, get_movement_input().y)
	# Updates the current speed based on if they're running or not
	var is_running := Input.is_action_pressed("run")
	current_speed = running_speed if is_running else walking_speed
	velocity = lerp(velocity, direction * current_speed, delta * 10.0)
	handle_footsteps(is_running)

func handle_footsteps(is_running: bool) -> void:
	# If the volume gets above FOOTSTEPS_BASE_VOLUME(-25), it makes sure the the volume stays at FOOTSTEPS_BASE_VOLUME(-25) 
	footsteps_sfx.volume_db = min(footsteps_sfx.volume_db, FOOTSTEPS_BASE_VOLUME)
	#If the player is moving, things happned
	if abs(velocity.length()) > 0:
		audio_hanlder_player.stop()
		footsteps_sfx.volume_db = FOOTSTEPS_BASE_VOLUME
		# Only play footsteps if timer has expired
		if footsteps_timer.time_left <= 0:
			if is_running:
				footsteps_sfx.pitch_scale = randf_range(1.1, 1.2)
				footsteps_sfx.volume_db *= 1.5
				footsteps_timer.start(0.22)
			else:
				footsteps_sfx.pitch_scale = randf_range(0.5, 0.8)
				footsteps_timer.start(0.3)
			# Play footstep sound
			footsteps_sfx.play()
			footstep_number += 1
	# Stop footsteps when the player releases input
	elif get_movement_input() == Vector2.ZERO:
		audio_hanlder_player.play("Fade_Out")

func hold_breath() -> void:
	var holding_breath := Input.is_action_pressed("hold_breath")
	if holding_breath:
		#holding_breath_sfx.play()
		#holding_breath_ambiance.play()
		current_speed /= 2.0

func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "forward", "backward")

func _on_footsteps_fading_out_animation_finished(_anim_name: StringName) -> void:
	if footsteps_sfx.volume_db == -80:
		footsteps_sfx.stop()
		footsteps_sfx.volume_db = FOOTSTEPS_BASE_VOLUME
