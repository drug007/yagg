module yagg.backend.simple.bitmap;

// Taken from rosetta code
import std.stdio, std.array, std.exception, std.string, std.conv,
       std.algorithm, std.ascii;

final class Image(T) {
    static if (is(typeof({ auto x = T.black; })))
        const static T black = T.black;
    else
        const static T black = T.init;
    static if (is(typeof({ auto x = T.white; })))
        const static T white = T.white;

    T[] image;
    private size_t nx_, ny_;

    this(in int nxx=0, in int nyy=0, in bool inizialize=true)
    pure nothrow {
        allocate(nxx, nyy, inizialize);
    }

    void allocate(in int nxx=0, in int nyy=0, in bool inizialize=true)
    pure nothrow in {
        assert(nxx >= 0 && nyy >= 0);
    } body {
        this.nx_ = nxx;
        this.ny_ = nyy;
        if (nxx * nyy > 0) {
            if (inizialize)
                image.length = nxx * nyy;
            else // Optimization.
                image = minimallyInitializedArray!(typeof(image))
                                                  (nxx * nyy);
        }
    }

    static Image fromData(T[] data, in size_t nxx=0, in size_t nyy=0)
    pure nothrow in {
        assert(nxx >= 0 && nyy >= 0 && data.length == nxx * nyy);
    } body {
        auto result = new Image();
        result.image = data;
        result.nx_ = nxx;
        result.ny_ = nyy;
        return result;
    }

    @property size_t nx() const pure nothrow { return nx_; }
    @property size_t ny() const pure nothrow { return ny_; }

    ref T opIndex(in size_t x, in size_t y) pure nothrow
    in {
        assert(x < nx_ && y < ny_);
    } body {
        return image[x + y * nx_];
    }

    T opIndex(in size_t x, in size_t y) const pure nothrow
    in {
        assert(x < nx_ && y < ny_);
    } body {
        return image[x + y * nx_];
    }

    T opIndexAssign(in T color, in size_t x, in size_t y) pure nothrow
    in {
        assert(x < nx_ && y < ny_);
    } body {
        return image[x + y * nx_] = color;
    }

    void opIndexUnary(string op)(in size_t x, in size_t y) pure nothrow
    if (op == "++" || op == "--") in {
        assert(x < nx_ && y < ny_);
    } body {
        mixin("image[x + y * nx_] " ~ op ~ ";");
    }

    void clear(in T color=this.black) pure nothrow {
        image[] = color;
    }
}


struct RGB {
    ubyte r, g, b;
    static immutable black = typeof(this)();
    static immutable white = typeof(this)(255, 255, 255);
}
