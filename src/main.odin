package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "vendor:raylib"

screen_width :: 800
screen_hight :: 450

GameState :: struct {
	move_input:     raylib.Vector2,
	ball_position:  raylib.Vector2,
	ball_direction: raylib.Vector2,
	ball_speed:     f32,
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

init :: proc() -> GameState {
	raylib.SetConfigFlags({raylib.ConfigFlag.MSAA_4X_HINT})
	raylib.InitWindow(screen_width, screen_hight, "odin + raylib")
	raylib.SetTargetFPS(60)

	return(
		GameState {
			move_input = raylib.Vector2{0, 0},
			ball_position = raylib.Vector2{screen_width / 2, screen_hight / 2},
			ball_direction = raylib.Vector2{0, 0},
			ball_speed = 3.0,
		}
	)
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
		game_state.ball_position + game_state.ball_direction * game_state.ball_speed
}

render :: proc(game_state: ^GameState) {
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)
	raylib.DrawCircleV(game_state.ball_position, 25, raylib.Color{4, 117, 62, 255})
	raylib.EndDrawing()
}

main :: proc() {
	game_state := init()

	for !raylib.WindowShouldClose() {
		update(&game_state)
		render(&game_state)
	}

	raylib.CloseWindow()
}
