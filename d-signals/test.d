import std.stdio;

import signals;

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

    signal.disconnect(s2);
    signal.emit(20, "roflmao");
}
