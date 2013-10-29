module yagg.backend.simple.line;

// Taken from rosetta code
import std.algorithm, std.math, yagg.backend.simple.bitmap;

void drawLine(Color)(Image!Color img,
                        int x1,    int y1,
                     in int x2, in int y2,
                     in Color color)
pure nothrow {
    immutable int dx = x2 - x1;
    immutable int ix = (dx > 0) - (dx < 0);
    immutable int dx2 = abs(dx) * 2;
    int dy = y2 - y1;
    immutable int iy = (dy > 0) - (dy < 0);
    immutable int dy2 = abs(dy) * 2;
    img[x1, y1] = color;

    if (dx2 >= dy2) {
        int error = dy2 - (dx2 / 2);
        while (x1 != x2) {
            if (error >= 0 && (error || (ix > 0))) {
                error -= dx2;
                y1 += iy;
            }

            error += dy2;
            x1 += ix;
            img[x1, y1] = color;
        }
    } else {
        int error = dx2 - (dy2 / 2);
        while (y1 != y2) {
            if (error >= 0 && (error || (iy > 0))) {
                error -= dy2;
                x1 += ix;
            }

            error += dx2;
            y1 += iy;
            img[x1, y1] = color;
        }
    }
}
