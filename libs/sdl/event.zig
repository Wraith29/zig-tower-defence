const std = @import("std");
const c = @cImport({
    @cInclude("SDL.h");
});
pub const Scancode = @import("./scancode.zig").Scancode;
pub const Keycode = @import("./keycode.zig").Keycode;
pub const Keysym = struct {
    scancode: Scancode,
    keycode: Keycode,
    mod: u16,
    unused: u32,
    pub fn from(ks: c.SDL_Keysym) Keysym {
        var scancode = @intToEnum(Scancode, ks.scancode);
        var keycode = @intToEnum(Keycode, ks.sym);
        return Keysym{
            .scancode = scancode,
            .keycode = keycode,
            .mod = ks.mod,
            .unused = ks.unused,
        };
    }
};
pub const SdlVersion = struct {
    major: u8,
    minor: u8,
    patch: u8,
};
pub const Event = struct {
    type: union(enum) {
        audio_device: struct {
            which: u32,
            iscapture: u8,
        },
        controller_axis: struct {
            which: i32,
            axis: u8,
            value: i16,
        },
        controller_button: struct {
            which: i32,
            button: u8,
            state: u8,
        },
        controller_device: struct {
            which: i32,
        },
        dollar_gesture: struct {
            touch_id: i64,
            gesture_id: i64,
            num_fingers: u32,
            err: f32,
            x: f32,
            y: f32,
        },
        drop: struct {
            file: [*c]u8,
            window_id: u32,
        },
        touch_finger: struct {
            touch_id: i64,
            finger_id: i64,
            x: f32,
            y: f32,
            dx: f32,
            dy: f32,
            pressure: f32,
            window_id: u32,
        },
        keyboard: struct {
            window_id: u32,
            state: u8,
            repeat: u8,
            keysym: Keysym,
        },
        joy_axis: struct {
            which: i32,
            axis: u8,
            value: i16,
        },
        joy_ball: struct {
            which: i32,
            ball: u8,
            x_rel: i16,
            y_rel: i16,
        },
        joy_hat: struct {
            which: i32,
            hat: u8,
            value: u8,
        },
        joy_button: struct {
            which: i32,
            button: u8,
            state: u8,
        },
        joy_device: struct {
            which: i32,
        },
        mouse_motion: struct {
            window_id: u32,
            which: u32,
            state: u32,
            x: i32,
            y: i32,
            x_rel: i32,
            y_rel: i32,
        },
        mouse_button: struct {
            window_id: u32,
            which: u32,
            button: u8,
            state: u8,
            clicks: u8,
            x: i32,
            y: i32,
        },
        mouse_wheel: struct {
            window_id: u32,
            which: u32,
            x: i32,
            y: i32,
            direction: u32,
            precise_x: f32,
            precise_y: f32,
        },
        multi_gesture: struct {
            touch_id: i64,
            d_theta: f32,
            d_dist: f32,
            x: f32,
            y: f32,
            num_fingers: u16,
        },
        quit: void,
        sys_wm: struct {
            msg: ?*c.SDL_SysWMmsg,
        },
        text_editing: struct {
            window_id: u32,
            text: [32]u8,
            start: i32,
            length: i32,
        },
        text_input: struct {
            window_id: u32,
            text: [32]u8,
        },
        user: struct {
            window_id: u32,
            code: i32,
            data1: ?*anyopaque,
            data2: ?*anyopaque,
        },
        window: struct {
            window_id: u32,
            event: u8,
            data1: i32,
            data2: i32,
        },
    },

    event_type: u32,
    timestamp: u32,

    pub fn from(event: c.SDL_Event) Event {
        return Event{
            .event_type = event.common.type,
            .timestamp = event.common.timestamp,
            .type = switch (event.type) {
                c.SDL_AUDIODEVICEADDED, c.SDL_AUDIODEVICEREMOVED => .{ .audio_device = .{
                    .which = event.adevice.which,
                    .iscapture = event.adevice.iscapture,
                } },
                c.SDL_CONTROLLERAXISMOTION => .{ .controller_axis = .{
                    .which = event.caxis.which,
                    .axis = event.caxis.axis,
                    .value = event.caxis.value,
                } },
                c.SDL_CONTROLLERBUTTONDOWN, c.SDL_CONTROLLERBUTTONUP => .{ .controller_button = .{
                    .which = event.cbutton.which,
                    .button = event.cbutton.button,
                    .state = event.cbutton.state,
                } },
                c.SDL_CONTROLLERDEVICEADDED, c.SDL_CONTROLLERDEVICEREMOVED, c.SDL_CONTROLLERDEVICEREMAPPED => .{ .controller_device = .{
                    .which = event.cdevice.which,
                } },
                c.SDL_DOLLARGESTURE, c.SDL_DOLLARRECORD => .{ .dollar_gesture = .{
                    .touch_id = event.dgesture.touchId,
                    .gesture_id = event.dgesture.gestureId,
                    .num_fingers = event.dgesture.numFingers,
                    .err = event.dgesture.@"error",
                    .x = event.dgesture.x,
                    .y = event.dgesture.y,
                } },
                c.SDL_DROPFILE, c.SDL_DROPTEXT, c.SDL_DROPBEGIN, c.SDL_DROPCOMPLETE => .{ .drop = .{
                    .file = event.drop.file,
                    .window_id = event.drop.windowID,
                } },
                c.SDL_FINGERMOTION, c.SDL_FINGERDOWN, c.SDL_FINGERUP => .{ .touch_finger = .{
                    .touch_id = event.tfinger.touchId,
                    .finger_id = event.tfinger.fingerId,
                    .x = event.tfinger.x,
                    .y = event.tfinger.y,
                    .dx = event.tfinger.dx,
                    .dy = event.tfinger.dy,
                    .pressure = event.tfinger.pressure,
                    .window_id = event.tfinger.windowID,
                } },
                c.SDL_KEYDOWN, c.SDL_KEYUP => .{ .keyboard = .{
                    .window_id = event.key.windowID,
                    .state = event.key.state,
                    .repeat = event.key.repeat,
                    .keysym = Keysym.from(event.key.keysym),
                } },
                c.SDL_JOYAXISMOTION => .{ .joy_axis = .{
                    .which = event.jaxis.which,
                    .axis = event.jaxis.axis,
                    .value = event.jaxis.value,
                } },
                c.SDL_JOYBALLMOTION => .{ .joy_ball = .{
                    .which = event.jball.which,
                    .ball = event.jball.ball,
                    .x_rel = event.jball.xrel,
                    .y_rel = event.jball.yrel,
                } },
                c.SDL_JOYHATMOTION => .{ .joy_hat = .{
                    .which = event.jhat.which,
                    .hat = event.jhat.hat,
                    .value = event.jhat.value,
                } },
                c.SDL_JOYBUTTONDOWN, c.SDL_JOYBUTTONUP => .{ .joy_button = .{
                    .which = event.jbutton.which,
                    .button = event.jbutton.button,
                    .state = event.jbutton.state,
                } },
                c.SDL_JOYDEVICEADDED, c.SDL_JOYDEVICEREMOVED => .{ .joy_device = .{
                    .which = event.jdevice.which,
                } },
                c.SDL_MOUSEMOTION => .{ .mouse_motion = .{
                    .window_id = event.motion.windowID,
                    .which = event.motion.which,
                    .state = event.motion.state,
                    .x = event.motion.x,
                    .y = event.motion.y,
                    .x_rel = event.motion.xrel,
                    .y_rel = event.motion.yrel,
                } },
                c.SDL_MOUSEBUTTONDOWN, c.SDL_MOUSEBUTTONUP => .{ .mouse_button = .{
                    .window_id = event.button.windowID,
                    .which = event.button.which,
                    .button = event.button.button,
                    .state = event.button.state,
                    .clicks = event.button.clicks,
                    .x = event.button.x,
                    .y = event.button.y,
                } },
                c.SDL_MOUSEWHEEL => .{ .mouse_wheel = .{
                    .window_id = event.wheel.windowID,
                    .which = event.wheel.which,
                    .x = event.wheel.x,
                    .y = event.wheel.y,
                    .direction = event.wheel.direction,
                    .precise_x = event.wheel.preciseX,
                    .precise_y = event.wheel.preciseY,
                } },
                c.SDL_MULTIGESTURE => .{ .multi_gesture = .{
                    .touch_id = event.mgesture.touchId,
                    .d_theta = event.mgesture.dTheta,
                    .d_dist = event.mgesture.dDist,
                    .x = event.mgesture.x,
                    .y = event.mgesture.y,
                    .num_fingers = event.mgesture.numFingers,
                } },
                c.SDL_QUIT => .quit,
                c.SDL_SYSWMEVENT => .{ .sys_wm = .{
                    .msg = event.syswm.msg,
                } },
                c.SDL_TEXTEDITING => .{ .text_editing = .{
                    .window_id = event.edit.windowID,
                    .text = event.edit.text,
                    .start = event.edit.start,
                    .length = event.edit.length,
                } },
                c.SDL_TEXTINPUT => .{ .text_input = .{
                    .window_id = event.text.windowID,
                    .text = event.text.text,
                } },
                c.SDL_USEREVENT => .{ .user = .{
                    .window_id = event.user.windowID,
                    .code = event.user.code,
                    .data1 = event.user.data1,
                    .data2 = event.user.data2,
                } },
                c.SDL_WINDOWEVENT => .{ .window = .{
                    .window_id = event.window.windowID,
                    .event = event.window.event,
                    .data1 = event.window.data1,
                    .data2 = event.window.data2,
                } },
                else => unreachable,
            },
        };
    }
};
pub fn pollEvent() ?Event {
    var event: c.SDL_Event = undefined;
    if (c.SDL_PollEvent(&event) != 0) return Event.from(event);
    return null;
}
