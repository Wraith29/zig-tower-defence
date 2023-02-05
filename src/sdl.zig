const std = @import("std");
const c = @cImport(@cInclude("SDL.h"));

const allocator = std.heap.c_allocator;
const event = @import("./sdl/event.zig");
const window = @import("./sdl/window.zig");
const renderer = @import("./sdl/renderer.zig");
const colour = @import("./sdl/colour.zig");
const rect = @import("./sdl/rect.zig");
const point = @import("./sdl/point.zig");

pub const panic = @import("./sdl/panic.zig").panic;
pub const Event = event.Event;
pub const Scancode = event.Scancode;
pub const pollEvent = event.pollEvent;
pub const Window = window.Window;
pub const Renderer = renderer.Renderer;
pub const Colour = colour.Colour;
pub const Rect = rect.Rect;
pub const Point = point.Point;

pub const SdlError = error{Init};

pub const InitFlags = struct {
    timer: bool = false,
    audio: bool = false,
    video: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    gamecontroller: bool = false,
    events: bool = false,
    everything: bool = false,
    noparachute: bool = false,

    pub fn toFlag(self: *const InitFlags) u32 {
        var res: u32 = 0;

        if (self.timer) res |= c.SDL_INIT_TIMER;
        if (self.audio) res |= c.SDL_INIT_AUDIO;
        if (self.video) res |= c.SDL_INIT_VIDEO;
        if (self.joystick) res |= c.SDL_INIT_JOYYSTICK;
        if (self.haptic) res |= c.SDL_INIT_HAPTIC;
        if (self.gamecontroller) res |= c.SDL_INIT_GAMECONTROLLER;
        if (self.events) res |= c.SDL_INIT_EVENTS;
        if (self.everything) res |= c.SDL_INIT_EVERYTHING;
        if (self.noparachute) res |= c.SDL_INIT_NOPNOPARACHUTE;

        return res;
    }
};

pub fn init(opt: InitFlags) SdlError!void {
    var flags: u32 = 0;

    if (opt.video) flags |= c.SDL_INIT_VIDEO;
    if (opt.audio) flags |= c.SDL_INIT_AUDIO;
    if (opt.events) flags |= c.SDL_INIT_EVENTS;

    if (c.SDL_Init(flags) < 0) return SdlError.Init;
}
