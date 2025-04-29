extends Node2D
class_name GameContainer

enum RealityMode {NORMAL, HOT, COLD}

var main_menu = load("uid://c0tvrj084xnrs")
@export var initialScene: PackedScene = null
var current_scene: PackedScene = null
var audioPlayer: AudioStreamPlayer = null
var song: AudioStream = null
var spaceMusic = false
var maxVolume = 0
const spaceHot: AudioStreamMP3 = preload("uid://b5y0md8ofcfql")
const spaceCold: AudioStreamMP3 = preload("uid://cwoghes0bx5rl")
const spaceNormal: AudioStreamMP3 = preload("uid://bc28hpetnpkgp")
const finalFall: AudioStreamMP3 = preload("uid://wrcgch5ecpn3")

var audioPlayerNormal: AudioStreamPlayer = null
var audioPlayerHot: AudioStreamPlayer = null
var audioPlayerCold: AudioStreamPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initialScene: loadScene(initialScene)
	else: loadScene(main_menu)
	
func loadScene(scene: PackedScene):
	unloadScene()
	current_scene = scene
	var inst = current_scene.instantiate()
	await get_tree().process_frame
	add_child(inst)
	
func reloadScene():
	loadScene(current_scene)
			
func unloadScene():
	if not current_scene: return
	var tweens = get_tree().get_processed_tweens()
	for tween in tweens:
		tween.kill()
	for child in get_children():
		if child.scene_file_path == current_scene.resource_path:
			call_deferred("remove_child", child)
			child.queue_free()
			return

func initAudioPlayer(music: AudioStream, fade: bool, maxVol: float, spaceMode: bool):
	song = music
	maxVolume = maxVol
	spaceMusic = spaceMode
	
	spaceMusicDestroy()
	if audioPlayer: 
		audioPlayer.queue_free()
		# necessary, otherwise new player will not play
		await get_tree().process_frame
	audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	if PlayerGlobalVars.doFinalFallMusic:
		audioPlayer.stream = finalFall
		audioPlayer.play()
	elif song and not spaceMusic:
		audioPlayer.stream = song
		audioPlayer.play()
	elif spaceMusic:
		spaceMusicInit()
	if fade:
		fadeInMusic()
	else:
		audioPlayer.volume_db = maxVolume - 5
		
func spaceMusicInit():
	
	if not spaceMusic or PlayerGlobalVars.doFinalFallMusic: return
	
	spaceMusicDestroy()

	# necessary, otherwise new player will not play
	await get_tree().process_frame
	
	audioPlayerNormal = AudioStreamPlayer.new()
	audioPlayerCold = AudioStreamPlayer.new()
	audioPlayerHot = AudioStreamPlayer.new()
	audioPlayerNormal.stream = spaceNormal
	audioPlayerCold.stream = spaceCold
	audioPlayerHot.stream = spaceHot
	
	add_child(audioPlayerCold)
	add_child(audioPlayerHot)
	add_child(audioPlayerNormal)
	
	var reality = Level.getLevelObject(get_tree()).reality
	if reality == RealityMode.NORMAL:
		audioPlayer = audioPlayerNormal
	elif reality == RealityMode.HOT:
		audioPlayer = audioPlayerHot
	else:
		audioPlayer = audioPlayerCold
		
	if audioPlayerNormal != audioPlayer: audioPlayerNormal.volume_db = -80
	if audioPlayerHot != audioPlayer: audioPlayerHot.volume_db = -80
	if audioPlayerCold != audioPlayer: audioPlayerCold.volume_db = -80
	
	audioPlayer.volume_db = maxVolume
	
	audioPlayerNormal.play()
	audioPlayerCold.play()
	audioPlayerHot.play()
	
func spaceMusicCrossfade():
	if not audioPlayer or not audioPlayerCold or not audioPlayerHot or not audioPlayerNormal: return
	
	var reality = Level.getLevelObject(get_tree()).reality
	var oldAudioPlayer = audioPlayer
	if reality == RealityMode.NORMAL:
		audioPlayer = audioPlayerNormal
	elif reality == RealityMode.HOT:
		audioPlayer = audioPlayerHot
	else:
		audioPlayer = audioPlayerCold
	var crossfade_duration = 0.1
	var tween = create_tween()
	tween.tween_property(oldAudioPlayer, "volume_db", -20, crossfade_duration)
	var tween2 = create_tween()
	tween2.tween_property(audioPlayer, "volume_db", maxVolume, crossfade_duration)
	tween2.finished.connect(func():
		oldAudioPlayer.volume_db = -80
	)
	

func spaceMusicDestroy():
	if audioPlayerCold: audioPlayerCold.queue_free()
	if audioPlayerHot: audioPlayerHot.queue_free()
	if audioPlayerNormal: audioPlayerNormal.queue_free()
	
	audioPlayerCold = null
	audioPlayerHot = null
	audioPlayerNormal = null

func fadeMusic(duration):
	if not audioPlayer: return
	var tween = create_tween()
	tween.tween_property(audioPlayer, "volume_db", -80, duration)
	tween.finished.connect(func():
		audioPlayer.volume_db = -80
		audioPlayer.stop()
	)
	
func fadeInMusic():
	audioPlayer.volume_db = -80
	var tween = create_tween()
	tween.tween_property(audioPlayer, "volume_db", maxVolume, 1.0)
	tween.finished.connect(func():
		audioPlayer.volume_db = maxVolume - 5
		#fadeTweens
	)
	
static func get_game_container(sceneTree: SceneTree) -> GameContainer:
	for child in sceneTree.root.get_children():
		if child is GameContainer: return child
	return null
