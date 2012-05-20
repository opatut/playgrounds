# Fast Fourier Transform

## test.d

Just does some simple wave generation and then performs a FFT on it to read back the frequencies.

## visualizer.d

This is a useful test case. It reads data from a FIFO stream (/tmp/mpd.fifo) and prints a nice spectral graph. Works well with MPD. The entry in /etc/mpd.conf will look like this:

    audio_output {
        type    "fifo"
        name    "Visualizer"
        path    "/tmp/mpd.fifo"
        format  "44100:16:1"
    }

You can of course change the path or the name.
