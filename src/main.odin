package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "vendor:raylib"

win_width :: 800
win_hight :: 450
delta_time: f32 = 0.0

GameState :: struct {
	// player input
	move_input:     raylib.Vector2,

	// ball object
	ball_position:  raylib.Vector2,
	ball_direction: raylib.Vector2,
	ball_speed:     f32,
}

main :: proc() {
	game_state := init_game()
	defer deinit_game()

	for !raylib.WindowShouldClose() {
		delta_time = raylib.GetFrameTime()
		raylib.DrawFPS(10, 10)

		update(&game_state)
		render(&game_state)
	}
}

init_game :: proc() -> GameState {
	raylib.SetConfigFlags(
		{
			raylib.ConfigFlag.WINDOW_RESIZABLE,
			raylib.ConfigFlag.MSAA_4X_HINT,
			raylib.ConfigFlag.VSYNC_HINT,
		},
	)
	raylib.InitWindow(win_width, win_hight, "odin + raylib")
	raylib.SetTargetFPS(60)

	initial_state := GameState {
		move_input     = raylib.Vector2{0, 0},
		ball_position  = raylib.Vector2{win_width / 2, win_hight / 2},
		ball_direction = raylib.Vector2{0, 0},
		ball_speed     = 200.0,
	}
	return initial_state
}

deinit_game :: proc() {
	raylib.CloseWindow()
}

update :: proc(game_state: ^GameState) {
	// get input
	get_move_input(&game_state.move_input)

	// calculate ball direction
	game_state.ball_direction = {0, 0}
	if game_state.move_input != {0, 0} {
		game_state.ball_direction = linalg.normalize(game_state.move_input)
	}

	// translate ball position
	game_state.ball_position =
		game_state.ball_position + game_state.ball_direction * (game_state.ball_speed * delta_time)
}

render :: proc(game_state: ^GameState) {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)
	raylib.DrawCircleV(game_state.ball_position, 30, raylib.Color{94, 184, 255, 255})
	raylib.EndDrawing()
}

get_move_input :: proc(move_input: ^raylib.Vector2) {
	if raylib.IsKeyPressed(raylib.KeyboardKey.LEFT) do move_input.x = -1
	if raylib.IsKeyPressed(raylib.KeyboardKey.RIGHT) do move_input.x = +1
	if raylib.IsKeyPressed(raylib.KeyboardKey.UP) do move_input.y = -1
	if raylib.IsKeyPressed(raylib.KeyboardKey.DOWN) do move_input.y = +1

	if move_input.x == -1 && raylib.IsKeyReleased(raylib.KeyboardKey.LEFT) do move_input.x = 0
	if move_input.x == +1 && raylib.IsKeyReleased(raylib.KeyboardKey.RIGHT) do move_input.x = 0
	if move_input.y == -1 && raylib.IsKeyReleased(raylib.KeyboardKey.UP) do move_input.y = 0
	if move_input.y == +1 && raylib.IsKeyReleased(raylib.KeyboardKey.DOWN) do move_input.y = 0

	if move_input.x == 0 {
		if raylib.IsKeyDown(raylib.KeyboardKey.LEFT) do move_input.x = -1
		if raylib.IsKeyDown(raylib.KeyboardKey.RIGHT) do move_input.x = +1
	}
	if move_input.y == 0 {
		if raylib.IsKeyDown(raylib.KeyboardKey.UP) do move_input.y = -1
		if raylib.IsKeyDown(raylib.KeyboardKey.DOWN) do move_input.y = +1
	}
}
