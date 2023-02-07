const std = @import("std");
const c = @cImport(@cInclude("SDL.h"));

fn getSdlErrorMessage() []const u8 {
    const msg = @as(?[*:0]const u8, c.SDL_GetError()) orelse "Unknown Error";
    return std.mem.sliceTo(msg, 0);
}

pub fn panic() noreturn {
    @panic(getSdlErrorMessage());
}
