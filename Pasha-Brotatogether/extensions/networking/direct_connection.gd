extends "res://mods-unpacked/Pasha-Brotatogether/extensions/networking/connection.gd"

var parent
	
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _player_connected(id):
	rpc("register_player")
	
func _player_disconnected(id):
	pass
	
func _connected_ok():
	var current_scene_name = get_tree().get_current_scene().get_name()
	if current_scene_name == "MultiplayerMenu":
		$"/root/MultiplayerMenu/HBoxContainer/InfoBox/Label".text = "connected"
	parent.self_peer_id = get_tree().get_network_unique_id()
	
func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remotesync func register_player():
	var id = get_tree().get_rpc_sender_id()
	if parent.is_host and not parent.tracked_players.has(id):
		parent.tracked_players[id] = {}
	
func send_state(game_state:Dictionary) -> void:
	rpc("update_game_state", game_state)

remote func update_game_state(game_state:Dictionary) -> void:
	parent.update_game_state(game_state)

func send_start_game(game_info:Dictionary) -> void:
	rpc("start_game", game_info)

remote func start_game(game_info: Dictionary) -> void:
	parent.start_game(game_info)

func send_display_floating_text(text_info:Dictionary) -> void:
	rpc("display_floating_text", text_info)
	
remote func display_floating_text(text_info:Dictionary) -> void:
	parent.display_floating_text(text_info)

func send_display_hit_effect(effect_info: Dictionary) -> void:
	rpc("display_hit_effect", effect_info)

remote func display_hit_effect(effect_info: Dictionary) -> void:
	parent.display_hit_effect(effect_info)

func send_enemy_death(enemy_id:int) -> void:
	rpc("enemy_death", enemy_id)

remote func enemy_death(enemy_id:int) -> void:
	parent.enemy_death(enemy_id)

func send_end_wave() -> void:
	rpc("end_wave")

remote func end_wave() -> void:
	parent.end_wave()
	
func send_flash_enemy(enemy_id:int) -> void:
	rpc("flash_enemy", enemy_id)

remote func flash_enemy(enemy_id:int) -> void:
	parent.flash_enemy(enemy_id)
	
func send_flash_neutral(neutral_id:int) -> void:
	rpc("flash_neutral", neutral_id)
			
remote func flash_neutral(neutral_id:int) -> void:
	parent.flash_neutral(neutral_id)
	
func send_client_position(client_position:Dictionary) -> void:
	rpc("update_client_position", client_position)

remote func update_client_position(client_position:Dictionary) -> void:
	parent.update_client_position(client_position)
	