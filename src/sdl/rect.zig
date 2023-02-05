const c = @cImport(@cInclude("SDL.h"));

pub const Rect = struct {
    internal: c.SDL_Rect,

    pub fn init(x: c_int, y: c_int, w: c_int, h: c_int) Rect {
        var rect = c.SDL_Rect{
            .x = x,
            .y = y,
            .w = w,
            .h = h,
        };

        return Rect{
            .internal = rect,
        };
    }
};
