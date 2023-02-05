const c = @cImport(@cInclude("SDL.h"));
const panic = @import("./panic.zig").panic;

const Window = @import("./window.zig").Window;
const Colour = @import("./colour.zig").Colour;
const Rect = @import("./rect.zig").Rect;
const Point = @import("./point.zig").Point;

pub const Renderer = struct {
    pub const RenderFlags = struct {
        software: bool = false,
        accelerated: bool = false,
        presentvsync: bool = false,
        targettexture: bool = false,

        pub fn toFlag(self: *const RenderFlags) u32 {
            var res: u32 = 0;

            if (self.software) res |= c.SDL_RENDERER_SOFTWARE;
            if (self.accelerated) res |= c.SDL_RENDERER_ACCELERATED;
            if (self.presentvsync) res |= c.SDL_RENDERER_PRESENTVSYNC;
            if (self.targettexture) res |= c.SDL_RENDERER_TARGETTEXTURE;

            return res;
        }
    };
    internal: *c.SDL_Renderer,

    pub fn init(window: *Window, flags: RenderFlags) Renderer {
        var internal = c.SDL_CreateRenderer(window.*.internal, -1, flags.toFlag()) orelse panic();

        return Renderer{
            .internal = internal,
        };
    }

    pub fn deinit(self: *Renderer) void {
        c.SDL_DestroyRenderer(self.internal);
    }

    pub fn setColour(self: *Renderer, colour: Colour) void {
        _ = c.SDL_SetRenderDrawColor(self.*.internal, colour.r, colour.g, colour.b, colour.a);
    }

    pub fn clear(self: *Renderer) void {
        _ = c.SDL_RenderClear(self.*.internal);
    }

    pub fn present(self: *Renderer) void {
        _ = c.SDL_RenderPresent(self.*.internal);
    }

    pub fn drawRect(self: *Renderer, rect: Rect) void {
        _ = c.SDL_RenderDrawRect(
            self.*.internal,
            &rect.internal,
        );
    }

    pub fn fillRect(self: *Renderer, rect: Rect) void {
        _ = c.SDL_RenderFillRect(
            self.*.internal,
            &rect.internal,
        );
    }

    pub fn drawLine(self: *Renderer, start: Point, end: Point) void {
        _ = c.SDL_RenderDrawLine(
            self.*.internal,
            start.x,
            start.y,
            end.x,
            end.y,
        );
    }

    pub fn drawPoint(self: *Renderer, point: Point) void {
        _ = c.SDL_RenderDrawPoint(
            self.*.internal,
            point.x,
            point.y,
        );
    }

    pub fn drawPoints(self: *Renderer, points: [*c]const Point, count: c_int) void {
        _ = c.SDL_RenderDrawPoints(
            self.*.internal,
            points,
            count,
        );
    }

    pub fn drawCircle(self: *Renderer, center: Point, radius: i32) void {
        const diameter = radius * 2;

        var x = radius - 1;
        var y: i32 = 0;
        var tx: i32 = 1;
        var ty: i32 = 1;
        var err: i32 = tx - diameter;

        while (x >= y) {
            var points = [_]Point{
                Point{ .x = center.x + x, .y = center.y - y },
                Point{ .x = center.x + x, .y = center.y + y },
                Point{ .x = center.x - x, .y = center.y - y },
                Point{ .x = center.x - x, .y = center.y + y },
                Point{ .x = center.x + y, .y = center.y - x },
                Point{ .x = center.x + y, .y = center.y + x },
                Point{ .x = center.x - y, .y = center.y - x },
                Point{ .x = center.x - y, .y = center.y + x },
            };

            var points_count: c_int = points.len;

            self.drawPoints(&points, points_count);

            if (err <= 0) {
                y += 1;
                err += ty;
                ty += 2;
            }

            if (err > 0) {
                x -= 1;
                tx += 2;
                err += (tx - diameter);
            }
        }
    }

    pub fn fillCircle(self: *Renderer, center: Point, radius: i32) void {
        var offset_x: i32 = 0;
        var offset_y: i32 = radius;
        var d: i32 = radius - 1;

        while (offset_y >= offset_x) {
            self.drawLine(.{
                .x = center.x - offset_y,
                .y = center.y + offset_x,
            }, .{
                .x = center.x + offset_y,
                .y = center.y + offset_x,
            });

            self.drawLine(.{
                .x = center.x - offset_x,
                .y = center.y + offset_y,
            }, .{
                .x = center.x + offset_x,
                .y = center.y + offset_y,
            });

            self.drawLine(.{
                .x = center.x - offset_x,
                .y = center.y - offset_y,
            }, .{
                .x = center.x + offset_x,
                .y = center.y - offset_y,
            });

            self.drawLine(.{
                .x = center.x - offset_y,
                .y = center.y - offset_x,
            }, .{
                .x = center.x + offset_y,
                .y = center.y - offset_x,
            });

            if (d >= 2 * offset_x) {
                d -= 2 * offset_x + 1;
                offset_x += 1;
            } else if (d < 2 * (radius - offset_y)) {
                d += 2 * offset_y - 1;
                offset_y -= 1;
            } else {
                d += 2 * (offset_y - offset_x - 1);
                offset_y -= 1;
                offset_x += 1;
            }
        }
    }
};
