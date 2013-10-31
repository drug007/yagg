module yagg.backend.simple.lookandfeel;

import yagg.backend.simple.bitmap: Image;
import yagg.backend.simple.line: drawLine;

struct RGBA {
    ubyte r, g, b, a;
}

class Surface
{
    /// coordinates of pen used to draw on the surface
    int penx, peny;
    /// current color used to draw on the surface
    RGBA color;
    /// actual image data
    Image!RGBA image;
    alias image this;

    this(int width, int height)
    {
        image = new Image!RGBA(width, height, true);
    }

    void moveTo(int x, int y)
    {
        penx = x;
        peny = y;
    }

    void lineTo(int x, int y)
    {
        image.drawLine(penx, peny, x, y, color);
    }
}

class LookAndFeel
{
    /// create surface with GL_RGBA compatible format
    static Surface createRGBASurface(int width, int height)
    {
        return new Surface(width, height);
    }

    static RGBA[] createButtonBackground(int width, int height)
    {
        auto surface = createRGBASurface(width, height);
        surface.color = RGBA(255, 0, 0, 255);
        surface.moveTo(0, 0);
        surface.lineTo(width-1, height-1);
        return surface.image.image;
    }
}