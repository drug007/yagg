module yagg.widget;

import yagg.placeholder;

// base class for widgets
class Widget
{
private:

    OnClick on_click_;

public:

    alias void delegate() OnClick;

    @property onClick(OnClick handler) { on_click_ = handler; }
    @property onClick() { if(on_click_ !is null) on_click_(); }

    Placeholder placeholder;
    bool visible;
    string caption;
    abstract void draw();
}
