module yagg.backend.cairo.lookandfeel;

import std.math: PI;
import std.conv: to;
import std.string: toStringz;

import cairo.c.cairo;

import yagg.gui: GUI;
import yagg.button: Button;

struct RGBA
{
    union
    {
        ubyte r, g, b, a;
        uint rgba;
    }

    this(uint rgba)
    {
        this.rgba = rgba;
    }

    this(ubyte r, ubyte g, ubyte b, ubyte a)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }
}

auto createRoundedRectangle(cairo_t* cr, double x, double y, double width, double height, bool isMouseOver)
{
    /* a custom shape that could be wrapped in a function */
    double corner_radius = height / 2.50;   /* corner curvature radius */

    double radius = corner_radius;
    double degrees = PI / 180.0;

    double border_width = 5;
    RGBA background_color;
    background_color.rgba = 0xffeeeeff;
    RGBA border_color;
    border_color.rgba =  0xff000000;

    if(isMouseOver)
    {
        background_color.r /= 1.2;
        background_color.g /= 1.2;
        background_color.b /= 1.2;
    }


    x += border_width / 2;
    y += border_width / 2;

    width -= border_width;
    height -= border_width;

    cairo_new_sub_path (cr);
    cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
    cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
    cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
    cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
    cairo_close_path (cr);

    cairo_set_source_rgb (cr, background_color.r, background_color.g, background_color.b);
    cairo_fill_preserve (cr);
    cairo_set_source_rgb (cr, border_color.r, border_color.g, border_color.b);
    cairo_set_line_width (cr, border_width);

    double grad_x = width/2;
    double grad_y = height/2;
    //auto pat = cairo_pattern_create_radial (grad_x, grad_y, 5,
    //                                        grad_x, grad_y, height/2);
    auto pat = cairo_pattern_create_linear (0, 0,
                                            0, height);
    cairo_pattern_add_color_stop_rgba (pat, 0, background_color.r*1.02/255, background_color.g*1.02/255, background_color.b*1.02/255, background_color.a/255);
    cairo_pattern_add_color_stop_rgba (pat, 1, background_color.r*0.575/255, background_color.g*0.575/255, background_color.b*0.575/255, background_color.a/255);
    cairo_set_source (cr, pat);
    //cairo_arc (cr, 128.0, 128.0, 76.8, 0, 2 * PI);
    cairo_fill (cr);
    cairo_pattern_destroy (pat);

    cairo_stroke (cr);
}

void drawText(cairo_t* cr, string text, int x, int y)
{
    cairo_set_source_rgb(cr, 0.1, 0.1, 0.1);
    cairo_select_font_face (cr, "Sans", cairo_font_slant_t.CAIRO_FONT_SLANT_NORMAL,
                                        cairo_font_weight_t.CAIRO_FONT_WEIGHT_NORMAL);
    cairo_set_font_size (cr, 14);

    auto text_zero = text.toStringz;
    cairo_text_extents_t extents;
    cairo_text_extents(cr, text_zero, &extents);
    cairo_move_to(cr, x - extents.width/2, y + extents.height/4);

    cairo_show_text (cr, text_zero);

    //cairo_move_to (cr, 0.0, 100.0);
    //cairo_text_path (cr, "void");
    cairo_set_source_rgb (cr, 0.5, 0.5, 1);
    cairo_fill_preserve (cr);
    cairo_set_source_rgb (cr, 0, 0, 0);
    cairo_set_line_width (cr, 2.56);
    cairo_stroke (cr);
}

class LookAndFeel
{

    static ubyte[] createButtonBackground(Button btn)
    {
        auto width = (GUI.width*btn.placeholder.width).to!int;
        auto height = (GUI.height*btn.placeholder.height).to!int;
        // allocate memory for data
        auto stride = cairo_format_stride_for_width(cairo_format_t.CAIRO_FORMAT_ARGB32, width);
        auto length = stride * height;
        ubyte[] data;
        data.length = length;

        // create surface and draw on it
        auto surface = cairo_image_surface_create_for_data (data.ptr, cairo_format_t.CAIRO_FORMAT_ARGB32, width, height, stride);
        auto cr = cairo_create (surface);
        createRoundedRectangle(cr, 0, 0, width, height, btn.isMouseOver);

        drawText(cr, btn.caption, width/2, height/2);

        return data;
    }
}