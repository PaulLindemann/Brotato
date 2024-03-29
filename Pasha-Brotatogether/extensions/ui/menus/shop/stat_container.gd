extends StatContainer

func update_stat() -> void:
	if not $"/root".has_node("GameController") or not $"/root/GameController".is_coop():
		.update_stat()
		return
	
	var game_controller = $"/root/GameController"

	var player = game_controller.tracked_players[game_controller.self_peer_id]
	var run_data = player.run_data
		
	var utils = $"/root/MultiplayerUtils"
		
	var stat_value = utils.get_stat_multiplayer(game_controller.self_peer_id, key.to_lower())
	var value_text = str(stat_value as int)
	
	_icon.texture = ItemService.get_stat_small_icon(key.to_lower())
	_label.text = key
	
	if key.to_lower() == "stat_dodge" and stat_value > run_data.effects["dodge_cap"]:
		value_text += " | " + str(run_data.effects["dodge_cap"] as int)
	elif key.to_lower() == "stat_max_hp" and run_data.effects["hp_cap"] < 9999:
		value_text += " | " + str(run_data.effects["hp_cap"] as int)
	elif key.to_lower() == "stat_speed" and run_data.effects["speed_cap"] < 9999:
		value_text += " | " + str(run_data.effects["speed_cap"] as int)
		
	_value.text = value_text
	
	if stat_value > 0:
		_label.modulate = Color.green
		_value.modulate = Color.green
	elif stat_value < 0:
		_label.modulate = Color.red
		_value.modulate = Color.red
	else :
		_label.modulate = Color.white
		_value.modulate = Color.white
