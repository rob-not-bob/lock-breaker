extends Node

signal event(event_name: String, data: Dictionary);
signal mute(is_muted: bool);

signal crit();
signal lost(score: int);
signal on_new_best_score(new_best_score: int);
