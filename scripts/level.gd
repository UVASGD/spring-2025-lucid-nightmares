extends Node2D
class_name Level

enum RealityMode {NORMAL, HOT, COLD}

@export var allowTelekinesis: bool = true
@export var reality: int = int(RealityMode.NORMAL)
@export var disableDoubleJump = false
@export var startingCheckpoint = 0
@export var startingElevator: StartElevator = null
@export var libraryLevel2: bool = false ## changes formula for sorting checkpoints
@export var song: AudioStreamMP3 = null
## Max volume in decibels
@export var maxVolume = 0
const spaceHot: AudioStreamMP3 = preload("uid://b5y0md8ofcfql")
const spaceCold: AudioStreamMP3 = preload("uid://cwoghes0bx5rl")
const spaceNormal: AudioStreamMP3 = preload("uid://bc28hpetnpkgp")
const finalFall: AudioStreamMP3 = preload("uid://wrcgch5ecpn3")

## Forces the player to choose hot or cold - cannot use neutral
var forceReality = false

var camera: CustomCamera = null
var player: Player = null
var checkpoints: Array[Checkpoint] = []

var escPresses = 0
var title: PackedScene = load("uid://c0tvrj084xnrs")

var audioPlayer: AudioStreamPlayer = null
@export var spaceMusic: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerGlobalVars.interactLectern: allowTelekinesis = true
	if not allowTelekinesis:
		get_tree().call_group("TelekineticControllers", "set_enabled", false)
	# Locate camera node and make sure it is in front
	for node in get_children():
		if node is CustomCamera:
			move_child(node, get_child_count())
			camera = node
		elif node is Player:
			player = node
		if player and camera:
			break
	
	if disableDoubleJump:
		player.AIR_JUMPS = 0
	
	if PlayerGlobalVars.firstLoad:
		var checkpoint = startingCheckpoint
		checkpoint -= int(bool(startingElevator != null))
		
		PlayerGlobalVars.reality = reality
		if checkpoint >= 0:
			checkpoint = min(checkpoint, checkpoints.size()-1)
			if checkpoint >= 0:
				camera.global_position += checkpoints[checkpoint].global_position - player.global_position
				player.global_position = checkpoints[checkpoint].global_position
				PlayerGlobalVars.respawnPoint = checkpoints[checkpoint].global_position
				player.checkpoint_phase = checkpoint
		elif startingElevator:
			startingElevator.player = player
			PlayerGlobalVars.respawnPoint = startingElevator.remoteTransform.global_position
			startingElevator.playAnimation()
	
	if not PlayerGlobalVars.firstLoad:
		reality = PlayerGlobalVars.reality
	
	if PlayerGlobalVars.firstLoad:
		initAudioPlayer(false)
	else:
		GameContainer.get_game_container(get_tree()).fadeInMusic()
	callRealityChange()
	PlayerGlobalVars.firstLoad = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		escPresses += 1
		if escPresses >= 2:
			camera.fadeToBlack()
			fadeMusic(1.0)
			await get_tree().create_timer(1).timeout
			GameContainer.get_game_container(get_tree()).loadScene(title)
		else:
			camera.quitLabel.text = "Press Esc again to quit to title screen"
			get_tree().create_timer(3).timeout.connect(resetQuit)
		
func initAudioPlayer(fade: bool):
	GameContainer.get_game_container(get_tree()).initAudioPlayer(song, fade, maxVolume, spaceMusic)

func resetQuit():
	escPresses -= 1
	camera.quitLabel.text = ""

func setAllowTelekinesis(allow: bool):
	allowTelekinesis = allow
	get_tree().call_group("TelekineticControllers", "set_enabled", allowTelekinesis)
	
func cycleRealityForward():
	reality += 1
	if reality > RealityMode.size() - 1: reality = 0
	if reality == 0 and forceReality: reality = 1
	callRealityChange()
	spaceMusicChange()

func cycleRealityBackward():
	reality -= 1
	if reality < 0: reality = RealityMode.size() - 1
	if reality == 0 and forceReality: reality = 2
	callRealityChange()
	spaceMusicChange()
	
# Considering moving to using a signal bus instead of groups. There's no way to enforce that this method exists
func callRealityChange():
	get_tree().call_group("RealityObject", "on_reality_change", reality)

## level reset: whether the level reset and we shouldn't update musicProgress
func spaceMusicChange():
	GameContainer.get_game_container(get_tree()).spaceMusicCrossfade()
	
func playFinalFallMusic():
	PlayerGlobalVars.doFinalFallMusic = true
	initAudioPlayer(false)
	
func fadeFinalFallMusic():
	if not PlayerGlobalVars.doFinalFallMusic: return
	PlayerGlobalVars.doFinalFallMusic = false
	fadeMusic(5.0)
	await get_tree().create_timer(5).timeout
	initAudioPlayer(true)
	

static func getLevelObject(sceneTree: SceneTree) -> Level:
	for child in GameContainer.get_game_container(sceneTree).get_children():
		if child.is_queued_for_deletion(): continue
		if child is Level: return child
	return null
	
func registerCheckpoint(checkpoint: Checkpoint):
	checkpoints.append(checkpoint)
	var sortCheckpoints = func (a, b): 
		if libraryLevel2:
			return a.global_position.y > b.global_position.y
		return a.global_position.x + abs(a.global_position.y) * 1 < b.global_position.x + abs(b.global_position.y) * 1.1
	checkpoints.sort_custom(sortCheckpoints)
	for i in range(checkpoints.size()):
		checkpoints[i].phase = i + int(bool(startingElevator != null))
	pass
	
func fadeMusic(duration):
	GameContainer.get_game_container(get_tree()).fadeMusic(duration)
