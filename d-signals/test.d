import std.stdio;

import signals;

class Test {
    string name;

    this(string name) {
        this.name = name;
    }

    void slotDelegate(int x, string y) {
        writefln("Delegate of test object %s: %s %s", this.name, x, y);
    }
}

void slot1(int i, string s) {
    writefln("SLOT 1: %s\t%s", i, s);
}

void slot2(int i, string s) {
    writefln("SLOT 2: %s\t%s", i, s);
}

void main() {
    Signal!(int, string) signal = new Signal!(int, string);

    uint s1 = signal.connect(&slot1);
    uint s2 = signal.connect(&slot2);

    signal.emit(10, "rofl");

    Test t1 = new Test("TestObject1");
    Test t2 = new Test("TestObject2");

    signal.connect(&t1.slotDelegate);
    signal.connect(&t2.slotDelegate);

    signal.disconnect(s2);
    signal.emit(20, "roflmao");
}
