Mime
======
![Mime](https://github.com/MauroEldritch/mime/blob/master/media/Icon.png "Mime")
# About Mime

Mime is an exploit for executing a BadMic vector attack on Mycroft, an open source voice assistant. It works by "mimicking" voice interactions by creating a rogue virtual microphone for a few seconds and "playing" pre-recorded voice samples to it. The attacker requires **no privileges** to either create the fake device, or to play the recorded samples on it.

A simple Proof-Of-Concept is available (`jacket.sh`). It will run specific voice samples asking for information on an argentine economist to Mycroft. It will also install a speedtest module bypassing the confirmation prompt.

The full tool, `Mime.rb`, allows the user to run pre-flight checks on the environment and specify samples to inject.

Also, an installation script for Mycroft (Docker-based) is available on the `bin/` folder.
As a disclaimer, I want to say that Mycroft is secure project. Mime does not exploits a vulnerability on it, but takes advantage of the underlying OS functionalities to execute this attack.
This talk was written as an experimental research so expect heavy changes to occur, and new voice assistants to be added.


## Requisites

```bash
#pactl, pulseaudio and ffmpeg are needed for both the PoC and Mime application. If you have Mycroft, then you surely have at least pactl & pulseaudio.
sudo apt install pulseaudio ffmpeg
```

## Features
- Attacker can inject any custom recording by placing it on the `samples/` folder.
- Exploitation is quick and clean, taking up to ten seconds.
- No privileges are required. Mimic needs Docker privileges to check if the container is running, but not for exploiting it. PoC requires no privileges.
- Auto-clean. Wether the exploitation succeeds or fails, all rogue devices are removed and original configuration is restored.


## Usage

Run:

```bash
#Sample should be stored in the samples/ directory.
./mime.rb What_Is_Plutonium.ogg
```

## Screenshot

![Screenshot](https://github.com/MauroEldritch/mime/blob/master/media/Mime.png "Screenshot")


## Conferences

|#| Date | Conference | Video | Slides |
|---|---|---|---|---|
|1| JAN-2021 | Bsides Panamá | - | https://docs.google.com/presentation/d/1KaydJmaMvRgijMzEkG_ERjLYirWhqnSgpqO3v7sU8zM/edit?usp=sharing