const std = @import("std");
const sdl = @import("sdl");
const Game = @import("./game.zig").Game;

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

    var game = Game.init();

    mainloop: while (true) {
        while (sdl.pollEvent()) |event| {
            switch (event.type) {
                .quit => break :mainloop,
                else => {},
            }
        }

        renderer.setColour(sdl.Colour.Red);
        renderer.clear();
        game.draw(&renderer);

        renderer.present();
        break :mainloop;
    }

    std.debug.print("{any}\n", .{game.map});
}
