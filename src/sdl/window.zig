const c = @cImport(@cInclude("SDL.h"));

const panic = @import("./panic.zig").panic;

pub const Window = struct {
    pub const WindowPos = enum {
        centered,

        pub fn toCInt(self: *const WindowPos) c_int {
            return switch (self.*) {
                .centered => c.SDL_WINDOWPOS_CENTERED,
            };
        }
    };

    pub const WindowFlags = struct {
        fullscreen: bool = false,
        fullscreen_desktop: bool = false,
        opengl: bool = false,
        vulkan: bool = false,
        shown: bool = false,
        hidden: bool = false,
        borderless: bool = false,
        resizable: bool = false,
        minimised: bool = false,
        maximised: bool = false,
        input_grabbed: bool = false,
        input_focus: bool = false,
        mouse_focus: bool = false,
        foreign: bool = false,
        allow_highdpi: bool = false,
        mouse_capture: bool = false,
        always_on_top: bool = false,
        skip_taskbar: bool = false,
        utility: bool = false,
        tooltip: bool = false,
        popup_menu: bool = false,

        pub fn toFlag(self: *const WindowFlags) u32 {
            var res: u32 = 0;

            if (self.fullscreen) res |= c.SDL_WINDOW_FULLSCREEN;
            if (self.fullscreen_desktop) res |= c.SDL_WINDOW_FULLSCREEN_DESKTOP;
            if (self.opengl) res |= c.SDL_WINDOW_OPENGL;
            if (self.vulkan) res |= c.SDL_WINDOW_VULKAN;
            if (self.shown) res |= c.SDL_WINDOW_SHOWN;
            if (self.hidden) res |= c.SDL_WINDOW_HIDDEN;
            if (self.borderless) res |= c.SDL_WINDOW_BORDERLESS;
            if (self.resizable) res |= c.SDL_WINDOW_RESIZABLE;
            if (self.minimised) res |= c.SDL_WINDOW_MINIMIZED;
            if (self.maximised) res |= c.SDL_WINDOW_MAXIMIZED;
            if (self.input_grabbed) res |= c.SDL_WINDOW_INPUT_GRABBED;
            if (self.input_focus) res |= c.SDL_WINDOW_INPUT_FOCUS;
            if (self.mouse_focus) res |= c.SDL_WINDOW_MOUSE_FOCUS;
            if (self.foreign) res |= c.SDL_WINDOW_FOREIGN;
            if (self.allow_highdpi) res |= c.SDL_WINDOW_ALLOW_HIGHDPI;
            if (self.mouse_capture) res |= c.SDL_WINDOW_MOUSE_CAPTURE;
            if (self.always_on_top) res |= c.SDL_WINDOW_ALWAYS_ON_TOP;
            if (self.skip_taskbar) res |= c.SDL_WINDOW_SKIP_TASKBAR;
            if (self.utility) res |= c.SDL_WINDOW_UTILITY;
            if (self.tooltip) res |= c.SDL_WINDOW_TOOLTIP;
            if (self.popup_menu) res |= c.SDL_WINDOW_POPUP_MENU;

            return res;
        }
    };

    pub const WindowInitOptions = struct {
        title: [*c]const u8,
        x: WindowPos,
        y: WindowPos,
        w: c_int,
        h: c_int,
        flags: WindowFlags,
    };

    internal: *c.SDL_Window,

    pub fn init(opt: WindowInitOptions) Window {
        var internal = c.SDL_CreateWindow(
            opt.title,
            opt.x.toCInt(),
            opt.y.toCInt(),
            opt.w,
            opt.h,
            opt.flags.toFlag(),
        ) orelse panic();

        return Window{
            .internal = internal,
        };
    }

    pub fn deinit(self: *Window) void {
        c.SDL_DestroyWindow(self.internal);
    }
};
