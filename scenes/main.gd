extends SubViewport

var lock_difficulty = 5;

func show_game_over_screen():
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func _ready():
	$lock/countdown.text = str(lock_difficulty);

func _on_lock_info_calculated(center, radius, trackWidth):
	$track.initialize(center, radius, trackWidth);

func _on_coin_collected():
	lock_difficulty -= 1;
	$lock/countdown.text = str(lock_difficulty);
	if lock_difficulty == 0:
		$track.direction = 0;
		await $lock.unlock();
		show_game_over_screen();

func _on_lose():
	print("lose")
	show_game_over_screen();
