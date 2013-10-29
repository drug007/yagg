module yagg.gui;

import std.exception: enforce;

import derelict.opengl3.gl3: GLint, glUniformMatrix4fv, GL_TRUE;
import glamour.shader: Shader;
import gl3n.linalg: mat4;
import yagg.widget;

class GUI
{
private:
    Shader program_;
    GLint unif_position_, unif_texcoord_, unif_mvpmatrix_;
    mat4 mvpmatrix_;

    enum string programSource = `
        #version 120
        vertex:
        in vec2 in_position;
        in vec2 in_coord;

        // mvpmatrix is the result of multiplying the model, view, and projection matrices */
        uniform mat4 mvpmatrix;

        out vec2 texCoord;
        void main(void)
        {
            gl_Position = mvpmatrix * vec4(in_position, 0, 1);
            texCoord = in_coord;
        }
        fragment:
        in vec2 texCoord;
        out vec4 color;

        uniform sampler2D gSampler;

        void main(void)
        {
            color = texture2D(gSampler, texCoord);
        }
        `;

    this(int width, int height)
    {
        width_ = width;
        height_ = height;

        program_ = new Shader("shader", programSource);
        unif_position_ = program_.get_attrib_location("in_position");
        unif_texcoord_ = program_.get_attrib_location("in_coord");
        unif_mvpmatrix_ = program_.get_uniform_location("mvpmatrix");

        computeMVPMatrices();
    }

    static GUI instance_;
    static int width_, height_;

    void computeMVPMatrices()
    {
        // set the matrix
        auto world = mat4.identity;
        auto view = mat4.identity;
        auto projection = mat4.orthographic(0, 1, 0/*1/aspect_ratio_*/, 1/*1/aspect_ratio_*/, -1, 1);
        mvpmatrix_ = projection * view * world;
    }

public:

    @property uniform_position() { return unif_position_; }
    @property uniform_texcoord() { return unif_texcoord_; }

    /// create gui with specific parameters. Must be called only time.
    static create(int width, int height)
    {
        enforce(instance_ is null);
        instance_ = new GUI(width, height);
        return instance_;
    }

    /// get instance of GUI. GUI must be created before calling this function.
    static getInstance()
    {
        enforce(instance_ !is null);
        return instance_;
    }

    @property static width() { return width_; }
    @property static height() { return height_; }

    Widget[] widgets;

    void addWidget(Widget w)
    {
        widgets ~= w;
    }

    /// does stuff that should be done every frame before rendering started.
    void prepareDrawing()
    {
        program_.bind();

        // set model-view-projection matrix
        glUniformMatrix4fv(unif_mvpmatrix_, 1, GL_TRUE, mvpmatrix_.value_ptr);
    }

    /// free resources
    void close()
    {
        program_.remove();
    }

}
