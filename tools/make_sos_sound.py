"""
Writes assets/sounds/sos.wav: "SOS" in Morse (· · · — — — · · ·) at 3 kHz, then a pause; victim mode
plays it in a loop. 3 kHz is where hearing is most sensitive and where whistles and piezo alarms sit,
so a rescuer can follow it through gaps in rubble. Standard library only.

Run: python3 tools/make_sos_sound.py
"""
import math
import struct
import wave
from pathlib import Path

RATE = 22050
FREQ = 3000.0
DOT = 0.12
FADE = 0.005


def tone(seconds):
    n = int(RATE * seconds)
    fade = int(RATE * FADE)
    out = []
    for i in range(n):
        gain = min(1.0, i / fade, (n - 1 - i) / fade)
        out.append(0.9 * gain * math.sin(2 * math.pi * FREQ * i / RATE))
    return out


def silence(seconds):
    return [0.0] * int(RATE * seconds)


def letter(units):
    out = []
    for u in units:
        out += tone(DOT * u) + silence(DOT)
    return out + silence(DOT * 2)


def main():
    samples = letter([1, 1, 1]) + letter([3, 3, 3]) + letter([1, 1, 1]) + silence(0.8)
    path = Path(__file__).resolve().parent.parent / "assets" / "sounds" / "sos.wav"
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(s * 32767)) for s in samples))
    print(f"{path}: {len(samples) / RATE:.2f} s")


if __name__ == "__main__":
    main()
