import std.functional;

class Signal(T...) {
    alias void delegate(T) D;
    alias void function(T) F;
    uint connection = 0;

    D[uint] slots;

    void emit(T t) {
        foreach(slot; slots) {
            slot(t);
        }
    }

    uint connect(D d) {
        this.connection++;
        this.slots[this.connection] = d;
        return this.connection;
    }

    uint connect(F f) {
        return connect(toDelegate(f));
    }

    void disconnect(uint connection) {
        D[uint] tmp;
        foreach(k, v; slots)
            if(k != connection)
                tmp[k] = v;
        this.slots = tmp;
    }
}

