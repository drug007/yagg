module yagg.placeholder;

// contains info about place and size of widget
class Placeholder
{
    double x, y, width, height;
    this(double x, double y, double width, double height)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}