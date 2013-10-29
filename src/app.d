module app;

import std.stdio;

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
    btn.placeholder = new Placeholder(.4, 0.1, .25, .1); // x, y, width, heigth
    btn.build();
    //btn.caption = "Test Button";
    //btn.onClick = ()
    //{
    //    writeln("Test Button1 clicked");
    //};

    gui.addWidget(btn);

    btn = new Button();
    btn.placeholder = new Placeholder(.2, 0.8, .25, .1); // x, y, width, heigth
    btn.build();
    //btn.caption = "Test Button";
    //btn.onClick = ()
    //{
    //    writeln("Test Button1 clicked");
    //};

    gui.addWidget(btn);

    app.drawHandler = ()
    {
        glClearColor(0, 0, 0, 1);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        gui.prepareDrawing();

        foreach(widget; gui.widgets)
            if(widget.visible) widget.draw();
    };

    app.run();
    return;
}