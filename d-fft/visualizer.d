import std.numeric;
import std.math;
import std.stdio;

T[2][] fourier(T)(T[] input, float bitrate) {
    auto samples = input.length;
    auto f = fft(input);
    T[2][] r = new T[2][f.length];
    for(int i = 0; i < samples; i++) {
        T y = cast(T)(f[i].re * f[i].re + f[i].im * f[i].im);
        T x = cast(T)(1.0 * i * bitrate / samples);

        r[i] = [x, y];
    }
    return r;
}

static const int bitrate = 44100;
static const int bufferSize = 4096; // bitrate / 16 / 50; // 20 ms !??

void main() {

    auto f = File("/tmp/mpd.fifo", "r"); 

    short[bufferSize] buffer;

    while(true) {
        auto b = f.rawRead(buffer);
        if(b.length < bufferSize) writeln("Buffer underflow");

        float fbuf[] = new float[buffer.length];
        for(int i = 0; i < buffer.length; ++i) {
            fbuf[i] = buffer[i];
        }

        auto r = fourier(fbuf, bitrate);

        // group
        float[2][] groups;
        int prev = 0, x = 0;
        float max = 0;
        for(int i = 1; i < r.length; i *= 2) {
            float value = 0;

            for(int j = prev; j < i; ++j) {
                value += r[j][1];
            }

            // value /= (i - prev);
            prev = i;

            if(value > max)
                max = value;

            groups ~= [r[i][0], value];
        }
        
        writeln();
        writeln();
        max = 1.5e+14;
        //max = 1.5e+12;
        foreach(pair; groups) {
            float k = pair[0], v = pair[1];
            v /= max;
            v = log10(v + 1); // I DON'T KNOW WHY THIS WORKS, but it seems good ;) 
            writef(" % 8.0f | ", k);
            for(int j = 0; j < v * 40.0; ++j)
                write("#");
            writeln();
        }

        // normalize
        // float max = 0;
        // foreach(v; r) if(v[1] > max && max < float.max) max = v[1];
        // if(max == 0 || max > float.max) continue;
        // writeln("max ", max);

        // float avg = 0;
        // float x = 0.5;
        // float next = 20;
        // for(int i = 0; i < r.length; i++) {
        //     if(r[i][0] > 400) break;

        //     float v = r[i][1] / max;
        //     avg += v;

        //     if(r[i][0] > next) {
        //         next += 20;
        //         writef("  %08s | ", r[i][0]);
        //         for(int j = 0; j < avg * 30.0 / x; ++j)
        //             write("#");
        //         writeln();

        //         avg = 0;
        //         x *= 2;
        //     } 
        // }
    }
    
    // auto r = fourier(input, bitrate);

    // FIND THE MAXIMUM
    // writefln(":: Searching for maximum values");
    // float max_x = 0, max_y = 0;
    // foreach(float[2] v; r) {
    //     float x = v[0], y = v[1];
    //     if(y > max_y) { 
    //         max_x = x; max_y = y;
    //     }
    // }
    // writefln("   Maximum at %s Hz (value: %s)", max_x, max_y);

}
