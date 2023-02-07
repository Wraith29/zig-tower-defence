const std = @import("std");
const sdl = @import("sdl");

const tile_width = 100;
const tile_height = 100;
const cols = 1600 / tile_width;
const rows = 900 / tile_height;

pub const Map = struct {
    pub const Tile = struct {
        pub const TileKind = enum { grass, path };

        x: i32,
        y: i32,
        kind: TileKind,

        pub fn init(x: i32, y: i32, kind: TileKind) *const Tile {
            std.debug.print("Initialising Tile\nx: {},\ny: {}\n", .{ x, y });
            return &Tile{
                .x = x,
                .y = y,
                .kind = kind,
            };
        }

        pub fn colour(self: *const Tile) sdl.Colour {
            return switch (self.kind) {
                .grass => sdl.Colour.Green,
                .path => sdl.Colour.Blue,
            };
        }

        pub fn draw(self: *const Tile, renderer: *sdl.Renderer) void {
            std.debug.print("Drawing Tile: {any}\n", .{self});

            var bounds = sdl.Rect.init(
                self.*.x,
                self.*.y,
                100,
                100,
            );

            renderer.setColour(self.colour());
            renderer.fillRect(bounds);
        }
    };

    tiles: []*const Tile,

    pub fn init() Map {
        var tiles = [_]*const Tile{ Tile.init(0, 0, .grass), Tile.init(100, 0, .grass), Tile.init(200, 0, .grass), Tile.init(300, 0, .grass), Tile.init(400, 0, .grass), Tile.init(500, 0, .grass), Tile.init(600, 0, .grass), Tile.init(700, 0, .grass), Tile.init(800, 0, .grass), Tile.init(900, 0, .grass), Tile.init(1000, 0, .grass), Tile.init(1100, 0, .grass), Tile.init(1200, 0, .grass), Tile.init(1300, 0, .grass), Tile.init(1400, 0, .grass), Tile.init(1500, 0, .grass), Tile.init(0, 100, .grass), Tile.init(100, 100, .grass), Tile.init(200, 100, .grass), Tile.init(300, 100, .grass), Tile.init(400, 100, .grass), Tile.init(500, 100, .grass), Tile.init(600, 100, .grass), Tile.init(700, 100, .grass), Tile.init(800, 100, .grass), Tile.init(900, 100, .grass), Tile.init(1000, 100, .grass), Tile.init(1100, 100, .grass), Tile.init(1200, 100, .grass), Tile.init(1300, 100, .grass), Tile.init(1400, 100, .grass), Tile.init(1500, 100, .grass), Tile.init(0, 200, .grass), Tile.init(100, 200, .grass), Tile.init(200, 200, .grass), Tile.init(300, 200, .grass), Tile.init(400, 200, .grass), Tile.init(500, 200, .grass), Tile.init(600, 200, .grass), Tile.init(700, 200, .grass), Tile.init(800, 200, .grass), Tile.init(900, 200, .grass), Tile.init(1000, 200, .grass), Tile.init(1100, 200, .grass), Tile.init(1200, 200, .grass), Tile.init(1300, 200, .grass), Tile.init(1400, 200, .grass), Tile.init(1500, 200, .grass), Tile.init(0, 300, .grass), Tile.init(100, 300, .grass), Tile.init(200, 300, .grass), Tile.init(300, 300, .grass), Tile.init(400, 300, .grass), Tile.init(500, 300, .grass), Tile.init(600, 300, .grass), Tile.init(700, 300, .grass), Tile.init(800, 300, .grass), Tile.init(900, 300, .grass), Tile.init(1000, 300, .grass), Tile.init(1100, 300, .grass), Tile.init(1200, 300, .grass), Tile.init(1300, 300, .grass), Tile.init(1400, 300, .grass), Tile.init(1500, 300, .grass), Tile.init(0, 400, .grass), Tile.init(100, 400, .grass), Tile.init(200, 400, .grass), Tile.init(300, 400, .grass), Tile.init(400, 400, .grass), Tile.init(500, 400, .grass), Tile.init(600, 400, .grass), Tile.init(700, 400, .grass), Tile.init(800, 400, .grass), Tile.init(900, 400, .grass), Tile.init(1000, 400, .grass), Tile.init(1100, 400, .grass), Tile.init(1200, 400, .grass), Tile.init(1300, 400, .grass), Tile.init(1400, 400, .grass), Tile.init(1500, 400, .grass), Tile.init(0, 500, .grass), Tile.init(100, 500, .grass), Tile.init(200, 500, .grass), Tile.init(300, 500, .grass), Tile.init(400, 500, .grass), Tile.init(500, 500, .grass), Tile.init(600, 500, .grass), Tile.init(700, 500, .grass), Tile.init(800, 500, .grass), Tile.init(900, 500, .grass), Tile.init(1000, 500, .grass), Tile.init(1100, 500, .grass), Tile.init(1200, 500, .grass), Tile.init(1300, 500, .grass), Tile.init(1400, 500, .grass), Tile.init(1500, 500, .grass), Tile.init(0, 600, .grass), Tile.init(100, 600, .grass), Tile.init(200, 600, .grass), Tile.init(300, 600, .grass), Tile.init(400, 600, .grass), Tile.init(500, 600, .grass), Tile.init(600, 600, .grass), Tile.init(700, 600, .grass), Tile.init(800, 600, .grass), Tile.init(900, 600, .grass), Tile.init(1000, 600, .grass), Tile.init(1100, 600, .grass), Tile.init(1200, 600, .grass), Tile.init(1300, 600, .grass), Tile.init(1400, 600, .grass), Tile.init(1500, 600, .grass), Tile.init(0, 700, .grass), Tile.init(100, 700, .grass), Tile.init(200, 700, .grass), Tile.init(300, 700, .grass), Tile.init(400, 700, .grass), Tile.init(500, 700, .grass), Tile.init(600, 700, .grass), Tile.init(700, 700, .grass), Tile.init(800, 700, .grass), Tile.init(900, 700, .grass), Tile.init(1000, 700, .grass), Tile.init(1100, 700, .grass), Tile.init(1200, 700, .grass), Tile.init(1300, 700, .grass), Tile.init(1400, 700, .grass), Tile.init(1500, 700, .grass), Tile.init(0, 800, .grass), Tile.init(100, 800, .grass), Tile.init(200, 800, .grass), Tile.init(300, 800, .grass), Tile.init(400, 800, .grass), Tile.init(500, 800, .grass), Tile.init(600, 800, .grass), Tile.init(700, 800, .grass), Tile.init(800, 800, .grass), Tile.init(900, 800, .grass), Tile.init(1000, 800, .grass), Tile.init(1100, 800, .grass), Tile.init(1200, 800, .grass), Tile.init(1300, 800, .grass), Tile.init(1400, 800, .grass), Tile.init(1500, 800, .grass) };

        return Map{
            .tiles = &tiles,
        };
    }

    pub fn draw(self: *const Map, renderer: *sdl.Renderer) void {
        for (self.tiles) |tile|
            tile.draw(renderer);
    }
};

pub const Game = struct {
    map: Map,

    pub fn init() Game {
        var map = Map.init();
        return Game{
            .map = map,
        };
    }

    pub fn draw(self: *Game, renderer: *sdl.Renderer) void {
        self.map.draw(renderer);
    }
};
