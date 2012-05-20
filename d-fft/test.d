import std.numeric;
import std.math;
import std.stdio;

float[2][] fourier(float[] input, float bitrate) {
    auto samples = input.length;
    auto f = fft(input);
    float[2][] r = new float[2][f.length];
    for(int i = 0; i < samples; i++) {
        float y = f[i].re * f[i].re + f[i].im * f[i].im;
        float x = 1.0 * i * bitrate / samples;

        r[i] = [x, y];
    }
    return r;
}

void main() {
    uint l = pow(2, 12);
    uint bitrate = 196608; // 192 kbit/s
    float freq1 = 440, amt1 = 1.0;
    float freq2 = 532, amt2 = 1.5;
    

    // GENERATE INPUT
    writefln(":: Generating samples", l, freq1);
    writefln("   Bitrate:   %s bit/s (%s kbps)", bitrate, bitrate / 1024.0);
    writefln("   Samples:   %s", l);
    writefln("   Length:    %.2f ms", l * 1000.0 / bitrate);
    writefln("   Voice #1:  %03.1f Hz, %3.f %%", freq1, amt1 * 100);
    writefln("   Voice #2:  %03.1f Hz, %3.f %%", freq2, amt2 * 100);

    float[] input = new float[l];
    for(int i = 0; i < l; i++) {
        input[i] = sin(2 * PI * i / bitrate * freq1) * amt1;
    }

    // overlaying different wave
    for(int i = 0; i < l; i++) {
        input[i] += sin(2 * PI * i / bitrate * freq2) * amt2;
    }

    // PERFORM FOURIER TRANSFORM
    writefln(":: Performing fourier transform");
    auto r = fourier(input, bitrate);

    // FIND THE MAXIMUM
    writefln(":: Searching for maximum values");
    float max_x = 0, max_y = 0;
    foreach(float[2] v; r) {
        float x = v[0], y = v[1];
        if(y > max_y) { 
            max_x = x; max_y = y;
        }
    }
    writefln("   Maximum at %s Hz (value: %s)", max_x, max_y);

}
