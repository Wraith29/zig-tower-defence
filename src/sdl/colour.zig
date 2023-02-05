const c = @cImport(@cInclude("SDL.h"));

pub const Colour = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub fn init(r: u8, g: u8, b: u8, a: u8) Colour {
        return Colour{.r = r, .g = g, .b = b, .a = a};
    }

    pub const White = .{ .r = 255, .g = 255, .b = 255, .a = 255 };
    pub const Black = .{ .r = 0, .g = 0, .b = 0, .a = 255 };
    pub const Red = .{ .r = 255, .g = 0, .b = 0, .a = 255 };
    pub const Green = .{ .r = 0, .g = 255, .b = 0, .a = 255 };
    pub const Blue = .{ .r = 0, .g = 0, .b = 255, .a = 255 };
};
