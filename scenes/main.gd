extends CanvasLayer

var best_score: int = 0:
	set(score):
		best_score = score;
		$MarginContainer/BestScore.text = "Best Score: " + str(score);

@onready var lock = $CenterContainer/SubViewportContainer/SubViewport/lock;

func show_game_over_screen(score: int):
	$TryAgain.set_scores(score, best_score)
	$AnimationPlayer.play("screen_shake");
	await $AnimationPlayer.animation_finished
	$TryAgain.show();

func load_game():
	var game_state = GameSaver.load_game();
	if game_state.has("best_score"):
		best_score = GameSaver.game_state.best_score;

func _ready():
	load_game();

func _on_lose(score: int):
	if score > best_score:
		best_score = score;
		GameSaver.game_state = {
			"best_score": best_score,
		};
		GameSaver.save_game();

	show_game_over_screen(score);


func _on_try_again_clicked():
	lock.reset();
	$AnimationPlayer.play("RESET");
	$TryAgain.hide();


func _on_lock_crit():
	$AnimationPlayer.play("crit");


func _on_mute_button_up():
	var master = AudioServer.get_bus_index("Master");
	var music = AudioServer.get_bus_index("Music");
	var muted = AudioServer.is_bus_mute(master);

	AudioServer.set_bus_mute(master, !muted);
	AudioServer.set_bus_mute(music, !muted);
