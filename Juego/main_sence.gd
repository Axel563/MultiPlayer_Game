extends Node

@onready var join_btn: Button = $CenterContainer/VBoxContainer/Join
@onready var hud: CenterContainer = $CenterContainer

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
##var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()


func _ready():
	##Engine.max_fps = 60
	join_btn.pressed.connect(_on_join_pressed)
	##var api = Steam.steamInitEx(true, 480, true)
	##print("Seamworks status:", api.status)
	

func _on_host_pressed():
	##peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, 3500)
	##multiplayer.multiplayer_peer = peer
	##peer.peer_connected.connect(_on_peer_connected)
	##peer.peer_connected.connect(_on_peer_disconnected)
	##hud.hide()
	##_on_peer_connected()
	peer.create_server(3500, 2)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_on_peer_connected()
	peer.peer_disconnected.connect(_on_peer_disconnected)
	
func _on_join_pressed():##(lobby_id: int, steam_id: int):##añadir "##" y (): (sino)
	##peer.connect_lobby(lobby_id)##borrar(sino)
	peer.create_client("localhost", 3500) ##quitar primeros "##" (sino)
	multiplayer.multiplayer_peer = peer
	hud.hide()



func _on_peer_connected(id: int = 1):
	var player_scene = load("res://_Game/Escenas y Scripts/character_body_2d.tscn")
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	add_child(player_instance, true)
	hud.hide()

func _input(event):
	if event.is_action_pressed("Reset"):
		print("Reseteado")
		get_tree().change_scene_to_file("res://_Game/Escenas y Scripts/node.tscn")
		
func _on_peer_disconnected(id: int):
	for child in get_children():
		if child is CharacterBody2D and child.name == str(id):
			child.queue_free()
