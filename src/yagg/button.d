module yagg.button;

import std.conv: to;

import glamour.vao: VAO;
import glamour.vbo: Buffer;
import glamour.texture: Texture2D;
import derelict.sdl2.sdl: SDL_PixelFormat, SDL_Color, SDL_CreateRGBSurface, SDL_FillRect, SDL_MapRGBA, SDL_FreeSurface;
import derelict.opengl3.gl3: glDrawArrays, glTexParameteri, glPixelStorei, glEnable, glDisable, glBlendFunc,
    GL_BLEND, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_TRIANGLE_STRIP, GL_RGBA, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, GL_UNSIGNED_BYTE, GL_TEXTURE_2D,
    GL_TEXTURE_MIN_FILTER, GL_LINEAR, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_WRAP_S, GL_REPEAT, GL_TEXTURE_WRAP_T, GL_UNPACK_ALIGNMENT, GL_FLOAT;

import yagg.gui: GUI;
import yagg.widget: Widget;
import yagg.placeholder: Placeholder;
//import yagg.backend.simple.backend: Backend;
import yagg.backend.cairo.lookandfeel: LookAndFeel;

class Button: Widget
{
    VAO vao;
    Buffer vertices;
    Buffer texcoords;
    Texture2D texture;

    this()
    {
        visible = true;
    }

    ~this()
    {
        close();
    }

    override void draw()
    {
        assert(vao !is null);
        assert(vertices !is null);
        assert(texcoords !is null);
        assert(texture !is null);

        vao.bind();
        texture.bind_and_activate();

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

        glDisable(GL_BLEND);

        texture.unbind();
        vao.unbind();
    }

    override void update()
    {
        close();
        texture = new Texture2D();

        auto data = LookAndFeel.createButtonBackground(this);

        auto width = (GUI.width*placeholder.width).to!int;
        auto height = (GUI.height*placeholder.height).to!int;
        texture.set_data(data, GL_RGBA, width, height, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

        vertices = new Buffer;
        texcoords = new Buffer;

        float[] dummy;
        dummy.length = 8;
        dummy[0] = placeholder.x + 0;
        dummy[1] = placeholder.y + 0.;
        dummy[2] = placeholder.x + placeholder.width;
        dummy[3] = placeholder.y + 0.;
        dummy[4] = placeholder.x + 0.;
        dummy[5] = placeholder.y + placeholder.height;
        dummy[6] = placeholder.x + placeholder.width;
        dummy[7] = placeholder.y + placeholder.height;

        vertices.set_data(dummy);
        dummy = [0, 1, 1, 1, 0, 0, 1, 0];
        texcoords.set_data(dummy);

        auto gui = GUI.getInstance();
        vao = new VAO();
        vao.bind();
        vertices.bind(gui.uniform_position, GL_FLOAT, 2, 0, 0);
        texcoords.bind(gui.uniform_texcoord, GL_FLOAT, 2, 0, 0);
        vao.unbind();
    }

    void close()
    {
        if(texcoords)
        {
            texcoords.remove();
            texcoords = null;
        }

        if(texture)
        {
            texture.remove();
            texture = null;
        }

        if(vertices)
        {
            vertices.remove();
            vertices = null;
        }

        if(vao)
        {
            vao.remove();
            vao = null;
        }
    }
}