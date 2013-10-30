module app;

import std.stdio;
import std.random;

import derelict.opengl3.gl3: glClearColor, glClear, GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT;

import sdlapp;
import yagg.gui;
import yagg.button;

void main(string[] args)
{
    auto width = 1024;
    auto height = 768;
    auto app = new SDLApp("SDL application", width, height);

    auto gui = GUI.create(width, height);
    scope(exit) gui.close();

    auto btn = new Button();
    btn.placeholder = new Placeholder(.3, 0.1, .25, .1); // x, y, width, heigth
    btn.build();
    //btn.caption = "Test Button";
    btn.onClick = delegate ()
    {
        writeln("Test Button1 clicked");
    };

    gui.addWidget(btn);

    btn = new Button();
    btn.placeholder = new Placeholder(.5, 0.15, .25, .1); // x, y, width, heigth
    btn.build();
    //btn.caption = "Test Button";
    btn.onClick = delegate ()
    {
        writeln("Test Button2 clicked");
    };

    gui.addWidget(btn);

    btn = new Button();
    btn.placeholder = new Placeholder(.2, 0.8, .25, .1); // x, y, width, heigth
    btn.build();
    ////btn.caption = "Test Button";
    btn.onClick = ()
    {
        writeln("Test Button3 clicked");
        btn.placeholder.x += uniform(-10, 10)/30.;
        with(btn.placeholder) if (x > 1 - width) x = 1 - width;
        with(btn.placeholder) if (x < width) x = width;

        btn.build();
    };

    gui.addWidget(btn);

    app.drawHandler = ()
    {
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        gui.prepareDrawing();

        foreach(widget; gui.widgets)
            if(widget.visible) widget.draw();
    };

    app.mouseButtonHandler = (int button, bool pressed, int x, int y)
    {
        //writefln("button: %d, pressed: %s, x: %d, y: %d", button, pressed, x, y);
        GUI.processMouseInput(button, pressed, x, y);
    };

    app.run();
    return;
}