import std.numeric;
import std.math;
import std.stdio;
import std.datetime;
import std.string;
import std.conv;
import std.random;
import derp.all;

class Dot {
public:
    Vector2 centerOfGravity;
    Vector2 speed;
    Vector2 pos;

    PolygonComponent shape;
    Node node;

    this(Node root, int id, Vector2 center, float radius, float speed) {
        node = new Node("dot-" ~ to!string(id), root);
        shape = new PolygonComponent("shape-" ~ to!string(id));
        shape.setPoints(rectangle(-0.01, -0.01, 0.02, 0.02));
        shape.color = Color(1, 1, 1, 1);
        root.attachComponent(shape);

        pos = center + Vector2(uniform(-1.0, 1.0), uniform(-1.0, 1.0)) * radius;
        this.speed = speed * Vector2(uniform(-1.0, 1.0), uniform(-1.0, 1.0));
    }

    void update(float delta) {
        pos += speed * delta;

        Vector2 dir = centerOfGravity - pos;
        speed += dir * delta;

        //node.position = Vector3(pos.x, pos.y, 0);
    }
}

void main() {
    // Create the window
    Window window = new Window("Hello World", 800, 600, Window.Mode.Windowed);
    window.backgroundColor = Color.Black;

    Node rootNode = new Node("rootNode");

    // View
    CameraComponent cam = window.viewports[0].currentCamera;
    cam.projectionMode = CameraComponent.ProjectionMode.Orthographic;
    cam.orthographicBounds = Rect(-1, -1, 2, 2); //-1, -1, 1, 1);
    rootNode.attachComponent(cam);

    Dot[] dots;
    for(int i = 0; i < 40; ++i) {
        float rad = uniform(0.1, 0.15);
        // dots ~= new Dot(rootNode, i, Vector2(0.2, 0.2), rad, 0.05);
        dots ~= new Dot(rootNode, i, Vector2(100, 100), 100, 50);
        //dots[$-1].shape.node.position = Vector3(100, 100, 0);
    }

    StopWatch clock;
    clock.start();

    while(window.isOpen) {
        TickDuration t = clock.peek();
        clock.reset();
        float delta = 1.0 * t.length / t.ticksPerSec;

        window.update();
        foreach(Dot dot; dots) {
            dot.update(delta);
        }

        window.clear();
        window.render();
        window.display();
    }
    window.close();
}
