const std = @import("std");
const sdl = @import("./sdl.zig");

pub fn main() !void {
    sdl.init(.{ .video = true, .audio = true, .events = true }) catch sdl.panic();

    var window = sdl.Window.init(.{
        .title = "Zig Tower Defence",
        .x = .centered,
        .y = .centered,
        .w = 1600,
        .h = 900,
        .flags = .{
            .shown = true,
        },
    });
    defer window.deinit();

    var renderer = sdl.Renderer.init(&window, .{ .accelerated = true });
    defer renderer.deinit();

    mainloop: while (true) {
        while (sdl.pollEvent()) |event| {
            switch (event.type) {
                .quit => break :mainloop,
                else => {},
            }
        }

        renderer.setColour(sdl.Colour.Red);
        renderer.clear();
        renderer.setColour(sdl.Colour.Blue);
        renderer.drawRect(sdl.Rect.init(100, 100, 100, 100));
        renderer.setColour(sdl.Colour.Green);
        renderer.fillRect(sdl.Rect.init(200, 100, 100, 100));
        renderer.drawLine(.{ .x = 100, .y = 200 }, .{ .x = 100, .y = 300 });

        renderer.setColour(sdl.Colour.Black);
        renderer.fillCircle(.{ .x = 500, .y = 500 }, 100);

        renderer.present();
    }
}
