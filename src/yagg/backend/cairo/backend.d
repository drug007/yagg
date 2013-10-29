module yagg.backend.cairo.backend;

import std.math: PI;
import std.conv: to;
import cairo.c.cairo;

import yagg.gui: GUI;

struct RGBA {
    ubyte r, g, b, a;
}

auto createRoundedRectangle(cairo_t* cr, double x, double y, double width, double height)
{
    /* a custom shape that could be wrapped in a function */
    double aspect        = width / height;    /* aspect ratio */
    double corner_radius = height / 10.0;   /* and corner curvature radius */

    double radius = corner_radius / aspect;
    double degrees = PI / 180.0;

    cairo_new_sub_path (cr);
    cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
    cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
    cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
    cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
    cairo_close_path (cr);

    cairo_set_source_rgb (cr, 0.5, 0.5, 1);
    cairo_fill_preserve (cr);
    cairo_set_source_rgba (cr, 0.5, 0, 0, 0.5);
    cairo_set_line_width (cr, 10.0);
    cairo_stroke (cr);
}

class Backend
{

    static ubyte[] createSubstrate(int width, int height)
    {
        // allocate memory for data
        auto stride = cairo_format_stride_for_width(cairo_format_t.CAIRO_FORMAT_ARGB32, width);
        auto length = stride * height;
        ubyte[] data;
        data.length = length;

        // create surface and draw on it
        auto surface = cairo_image_surface_create_for_data (data.ptr, cairo_format_t.CAIRO_FORMAT_ARGB32, width, height, stride);
        auto cr = cairo_create (surface);
        createRoundedRectangle(cr, 0, 0, width, height);

        return data;
    }
}