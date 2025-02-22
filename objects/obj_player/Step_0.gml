/// @description Insert description here
// You can write your code in this editor
sprite_index = global.hasGun ? spr_player_idle_gun : spr_player_idle; // reset
image_blend = c_white; //reset, red for contact during invuln
if (is_jumping) {
	if (keyboard_check(vk_space)) {
		v_speed = v_speed + jump_accel;
		in_air = true;
	} else {
		is_jumping = false;
	}
}

var dx = move_speed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));

if (global.playerControlsEnabled) {
	//if (keyboard_check(ord("D"))) {
	//	facing = 1;
	//} else if (keyboard_check(ord("A"))) {
	//	facing = -1;
	//}
} else {
	dx = 0;
}

var dy = v_speed;
v_speed = min(v_speed + grav, 15);
//show_debug_message(string(v_speed))

var t1 = tilemap_get_at_pixel(tilemap, bbox_left+17, bbox_bottom + 1) & tile_index_mask;
var t2 = tilemap_get_at_pixel(tilemap, bbox_right-16, bbox_bottom + 1) & tile_index_mask;

// if player on ground
if ((t1 != 0 || t2 != 0) || coyote_counter < 10) {
	if (t1 != 0 || t2 != 0) {
		coyote_counter = 0;
	} else {
		coyote_counter += 1;
	}
	
	if (global.playerControlsEnabled && keyboard_check(vk_space)) {
	//if (keyboard_check(vk_space)) {
		if (!audio_is_playing(player_jump)) {
			var snd = audio_play_sound(player_jump, 1, false); 
			audio_sound_gain(snd, 10, 0);
			audio_sound_set_track_position(snd, 0.2);
			//audio_sound_pitch(sfx_jump, choose(0.2, 0.5, 1, 1.5, 2));
		}
		coyote_counter = 10;
		v_speed = -jump_impulse;
		is_jumping = true;
		alarm[1] = max_jump_time;
		dx_in_air = dx;
		footstep_counter = 0;
		audio_stop_sound(player_footsteps);
	}
}

// do vertical movement
y += dy;
if (dy > 0) { // down
	var t1 = tilemap_get_at_pixel(tilemap, bbox_left+17, bbox_bottom) & tile_index_mask;
	var t2 = tilemap_get_at_pixel(tilemap, bbox_right-16, bbox_bottom) & tile_index_mask;
	
	if (t1 != 0 || t2 != 0) {
		var oldy = y;
		y = ((bbox_bottom & ~31) - 1) - sprite_bbox_bottom;
		
		t1 = tilemap_get_at_pixel(tilemap, bbox_left+17, bbox_bottom) & tile_index_mask;
	    t2 = tilemap_get_at_pixel(tilemap, bbox_right-16, bbox_bottom) & tile_index_mask;
		if (t1 != 0 || t2 != 0) {
			y = oldy;
			x = ((bbox_right & ~31) - 1) - sprite_bbox_right;
		}
		
		v_speed = 0;
		dx_in_air = 0;
		
		if (in_air == true) {
			in_air = false;
			if (!audio_is_playing(player_thud)) {
				var snd = audio_play_sound(player_thud, 1, false);
				audio_sound_gain(snd, 10, 0);
			}
		}
		
		if (dx != 0 && (keyboard_check(ord("D")) || keyboard_check(ord("A")))) {
			if (footstep_counter == 0) {
				var snd = audio_play_sound(player_footsteps, 1, false);
				audio_sound_set_track_position(snd, 7);
			}
			footstep_counter = (footstep_counter + 1) mod 20;
		}
		else {
			footstep_counter = 0;
			audio_stop_sound(player_footsteps);
		}

	} else {
		in_air = true;
		if (dx == 0) {
			dx_in_air = dx_in_air * 0.96;
			if (abs(dx_in_air) < 0.1) {
				dx_in_air = 0;
			}
			dx = dx_in_air;
		} else {
			dx_in_air = dx;
		}
	}
	
} else { // up 
	var t1 = tilemap_get_at_pixel(tilemap, bbox_left+17, bbox_top) & tile_index_mask;
	var t2 = tilemap_get_at_pixel(tilemap, bbox_right-16, bbox_top) & tile_index_mask;
	
	if (t1 != 0 || t2 != 0) {
		var oldy = y;
		y = ((bbox_top + 32) & ~31) - sprite_bbox_top;
		
		t1 = tilemap_get_at_pixel(tilemap, bbox_left+17, bbox_bottom) & tile_index_mask;
	    t2 = tilemap_get_at_pixel(tilemap, bbox_right-16, bbox_bottom) & tile_index_mask;
		if (t1 != 0 || t2 != 0) {
			y = oldy;
			x = ((bbox_right & ~31) - 1) - sprite_bbox_right;
		}
		
		v_speed = 0;
		dx_in_air = 0;
		
	} else if (dy != 0) {
		if (dx == 0) {
			dx_in_air = dx_in_air * 0.96;
			if (abs(dx_in_air) < 0.1) {
				dx_in_air = 0;
			}
			dx = dx_in_air;
		} else {
			dx_in_air = dx;
		}
	} else if (dy == 0) {
		dx_in_air = 0;
	}
	
}

// do horizontal movement
x += dx;
if (dx > 0) { // right
	var t1 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_top) & tile_index_mask;
	var t2 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_bottom) & tile_index_mask;
	var t3 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_top + sprite_height/2) & tile_index_mask;
	
	if (t1 != 0 || t2 != 0 || t3 != 0) {
		x = ((bbox_right & ~31) - 1) - sprite_bbox_right;
		dx_in_air = 0;
	}
} else { // left 
	var t1 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_top) & tile_index_mask;
	var t2 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_bottom) & tile_index_mask;
	var t3 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_top + sprite_height/2) & tile_index_mask;
	
	if (t1 != 0 || t2 != 0 || t3 != 0) {
		x = ((bbox_left + 32) & ~31) - sprite_bbox_left;
		dx_in_air = 0;
	}
}

// shoot - enables the alarm for laser hitbox's fire rate


if (mouse_check_button(mb_left) && global.hasGun && global.playerControlsEnabled) {
	if (mb_left_hold == false) {
		mb_left_hold = true;
		var snd = audio_play_sound(player_lightbeam, 1, false);
		audio_sound_gain(snd, 0.1, 0);
	}
	dir = point_direction(x, y, mouse_x, mouse_y); // update dir first, used both in step and draw
	if (dir < 90 || dir > 270) { // change orientation based on shooting direction
		facing = 1;
	} else {
		facing = -1;
	}
	firingDir = point_direction(x + gunOffsetX * facing, y, mouse_x, mouse_y); // account for offset

	if alarm[0] = -1 {
		alarm[0] = room_speed/fire_rate;
	}
} else {
	mb_left_hold = false;
}

// platform
if (instance_exists(obj_platform)) {
	y -= dy;
	var platform = instance_nearest(x, y, obj_platform);
	var on_platform = place_meeting(x, y + 1, platform) || (y <= platform.y - sprite_get_height(spr_player)/2 && y + dy > platform.y - sprite_get_height(spr_player)/2) && abs(platform.x - x) < platform.sprite_width/2;
	if (dy >= 0 && on_platform && y <= platform.y - sprite_get_height(spr_player)/2) {
		if (x_diff_set == false || dx != 0) {
			x_diff = platform.x - x;
			x_diff_set = true;
		}
		if (keyboard_check(vk_space)) {
			v_speed = -jump_impulse;
			is_jumping = true;
			alarm[1] = max_jump_time;
		} else {
			v_speed = 0;
			y = platform.y - sprite_get_height(spr_player)/2 - 12;
			new_x = platform.x - x_diff;
			
			// should have made these checks into scripts lmao
			if (new_x > x) { // right
				x = new_x;
				var t1 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_top) & tile_index_mask;
				var t2 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_bottom) & tile_index_mask;
				var t3 = tilemap_get_at_pixel(tilemap, bbox_right, bbox_top + sprite_height/2) & tile_index_mask;
	
				if (t1 != 0 || t2 != 0 || t3 != 0) {
					x = ((bbox_right & ~31) - 1) - sprite_bbox_right;
					dx_in_air = 0;
					x_diff_set = false;
				} 
			} else { // left 
				x = new_x;
				var t1 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_top) & tile_index_mask;
				var t2 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_bottom) & tile_index_mask;
				var t3 = tilemap_get_at_pixel(tilemap, bbox_left, bbox_top + sprite_height/2) & tile_index_mask;
	
				if (t1 != 0 || t2 != 0 || t3 != 0) {
					x = ((bbox_left + 32) & ~31) - sprite_bbox_left;
					dx_in_air = 0;
					x_diff_set = false;
				}
			}
		}
	} else {
		y += dy;
		x_diff_set = false;
	}
}

cooldown = max(0, cooldown - 1);

//if (keyboard_check_pressed(vk_alt)) {
//	invuln = !invuln;
//}