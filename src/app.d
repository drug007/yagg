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

    auto btnOne = new Button();
    btnOne.placeholder = new Placeholder(.3, 0.1, .55, .1); // x, y, width, heigth
    btnOne.caption = "Test Button1";
    btnOne.update();
    btnOne.onClick = delegate ()
    {
        static int count;
        btnOne.caption = format("Test Button1 is pressed %d time(s).", count++);
        btnOne.update();
    };

    gui.addWidget(btnOne);

    auto btnTwo = new Button();
    btnTwo.placeholder = new Placeholder(.2, 0.15, .25, .1); // x, y, width, heigth
    btnTwo.caption = "Test Button2";
    btnTwo.update();
    btnTwo.onClick = delegate ()
    {
        writeln("Test Button2 clicked");
    };

    gui.addWidget(btnTwo);

    auto btnThree = new Button();
    btnThree.placeholder = new Placeholder(.2, 0.8, .25, .1); // x, y, width, heigth
    btnThree.caption = "Test Button3";
    btnThree.update();
    btnThree.onClick = ()
    {
        writeln("Test Button3 clicked");
        btnThree.placeholder.x += uniform(-10, 10)/30.;
        with(btnThree.placeholder) if (x > 1 - width) x = 1 - width;
        with(btnThree.placeholder) if (x < width) x = width;

        btnThree.update();
    };

    gui.addWidget(btnThree);

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