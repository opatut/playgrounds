import std.numeric;
import std.math;
import std.stdio;
import std.string;
import derp.all;

struct DataPoint {
    float freq, amp;
    this(float f, float a) { freq = f; amp = a; }
}

alias DataPoint[] Data;

DataPoint[] fourier(float[] input, float bitrate) {
    auto samples = input.length;
    auto f = fft(input);
    DataPoint[] r;
    for(int i = 0; i < samples; i++) {
        float amp = cast(float)(f[i].re * f[i].re + f[i].im * f[i].im);
        float freq = cast(float)(1.0 * i * bitrate / samples);
        r ~= DataPoint(freq, amp);
    }
    return r;
}

float average(float[] input) {
    float x = 0;
    foreach(i; input) x += i;
    return x;
}

float rangeValue(Data d, float from, float to) {
    float[] vs;
    foreach(p; d) {
        if(p.freq >= bufferSize) continue;
        if(p.freq >= from && p.freq <= to)
            vs ~= p.amp;
    }
    return average(vs);
}

static const int bitrate = 192000;
static const int bufferSize = 2 * 8192; // bitrate / 16 / 50; // 20 ms !??
static const int barCount = 82;
static const int barWidth = 6;
static const int barMargin = 1;
static const int barHeight = 200;

void main() {
    // Create the window
    Window window = new Window("Hello World", 1088, 612, Window.Mode.Windowed);
    window.backgroundColor = Color.Black;

    ResourceManager resourceManager = new ResourceManager();
    Texture bg = resourceManager.loadT!Texture(new UrlString("data/bg.png"));
    Font font = resourceManager.loadT!Font(new UrlString("data/DejaVuSans.ttf"));
    font.pointSize = 20;

    Node rootNode = new Node("rootNode");
    Node spriteNode = new Node("spriteNode", rootNode);
    Node graphNode = new Node("graphNode", rootNode);
    Node fontNode = new Node("fontNode", rootNode);

    // Create sprite
    SpriteComponent sprite = new SpriteComponent("Sprite", bg);
    sprite.size = Vector2(1088, 612);
    sprite.smooth = true;
    spriteNode.attachComponent(sprite);
    spriteNode.position = Vector3(400, 300, 0);

    // Headline
    TextComponent text = new TextComponent("headline", "Music is awesome", font);
    text.color = Color.White;
    fontNode.attachComponent(text);
    fontNode.position = Vector3(400, 50, 0);

    // View
    CameraComponent cam = window.viewports[0].currentCamera;
    cam.projectionMode = CameraComponent.ProjectionMode.Orthographic;
    cam.orthographicBounds = Rect(0, 0, 800, 600);
    rootNode.attachComponent(cam);
    float m = 6;
    PolygonComponent outer = new PolygonComponent("outerShape");
    outer.color = Color(1, 1, 1, 0.1);
    outer.setPoints(rectangle(-m, m, barCount * (barWidth + barMargin) + 2 * m, - barHeight - 2 * m));
    graphNode.attachComponent(outer);

    // Graph
    graphNode.position = Vector3(40, 500, 0);
    PolygonComponent[] bars = new PolygonComponent[barCount];
    for(int i = 0; i < barCount; ++i) {
        bars[i] = new PolygonComponent(format("bar-%s", i));

        bars[i].setPoints(rectangle(0, 0, barWidth, -1.0 * i / barCount * barHeight));
        bars[i].color = Color(1, 1, 1, sin(1.0 * i / barCount * PI) * 0.8 + .2);

        Node n = new Node(format("barNode-%s", i), graphNode);
        n.position = Vector3(i * (barWidth + barMargin), 0, 0);
        n.attachComponent(bars[i]);
    }

    auto f = File("/tmp/mpd.fifo", "r"); 
    short[bufferSize] buffer;

    float[] values = new float[barCount];
    for(int i = 0; i < barCount; ++i) {
        values[i] = 1;
    }

    while(window.isOpen()) {
        auto b = f.rawRead(buffer);
        if(b.length < bufferSize) writeln("Buffer underflow");

        float fbuf[] = new float[buffer.length];
        for(int i = 0; i < buffer.length; ++i) {
            fbuf[i] = buffer[i];
        }

        DataPoint[] r = fourier(fbuf, bitrate);
        float fac = 1.0 / 1.5e+14 * 2;

        // float min = 40;
        // float max = 22000;

        float prev = 0;
        float[] tmpValues = new float[barCount];
        for(int i = 0; i < barCount; ++i) {
            float p = sqrt(1.15);
            int I = 26 * 2 + 3;
            float from = pow(p, i + I);
            float to = pow(p, i + 1 + I);

            float v = rangeValue(r, from, to) * fac;
            tmpValues[i] = v;
        }
        for(int i = 0; i < barCount; ++i) {
            float v = tmpValues[i];
            if(v == 0) {
                float s = 0, e = 0;
                int j = i, k = i;
                while(s == 0 && j > 0) {
                    s = tmpValues[j]; j--;
                }
                k = i;
                while(e == 0 && k < barCount) {
                    e = tmpValues[k]; k++;
                }

                v = (e - s) / (k * 1.0 / j) + s;
            }

            //v = log10(v + 1);
            v = 1 - pow(E, -v);
            float x = 0.8;
            values[i] = values[i] * x + (1-x) * v;

            auto bar = cast(PolygonComponent)graphNode.children[i].components[0];
            float V = values[i];
            float h = (- V) * barHeight;
            h -= barWidth;
            float w = barWidth;
            bar.setPoints(rectangle(0, 0, w, h));
            bar.color = Color(1, 1, 1, V * 0.8 + 0.2);
        }

        window.update();
        window.clear();
        window.render();
        window.display();
    }
    window.close();
}
