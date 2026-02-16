# frozen_string_literal: true

require 'date'

module Birthday
  extend self
  def update(i, o) # input, output
    if File.exist?(i)
      warn "File does not exist: #{i}"
      return false
    end
    today = Time.now
    month = Date::MONTHNAMES[today.month].downcase
    day = today.day

    new_content = File.read(i)
    (day - 1).times do |i|
      x = i + 1

      new_content = new_content.sub(%{id="day#{x}"}, %{id="day#{x}" style="opacity:40%"})
    end

    File.write(o, new_content)
  end
end

def jpg_for_now(num, raw_dir)
  dir   = File.join(Dir.pwd, raw_dir)
  jpgs  = `find "#{dir}" -maxdepth 1 -mindepth 1 -type f -iname '*.jpg' -or -iname '*.png' `.split
  index = (num % jpgs.size).to_i

  jpgs[index] || File.join(Dir.pwd, "images/chicken.drumstrick.01.jpg")
end # def

def jpg_for_min(raw_dir)
  jpg_for_now(Time.now.min, raw_dir)
end # def

def jpg_for_hour(raw_dir)
  jpg_for_now(Time.now.hour, raw_dir)
end # def

def jpg_for_today(raw_dir)
  jpg_for_now(Time.now.day, raw_dir)
end # def

def hide_mouse_cursor
  `xdotool mousemove 1980 100`
end

def minimize_windows
  `wmctrl -lxp | grep -vP 'lxpanel|pcmanfm' | cut -d' ' -f1`
    .strip
    .split("\n")
    .each { |x| x && x.size > 8 && `xdotool windowminimize "#{x}"` }
end

def process?(x)
  begin
    Process.getpgid(x)
    true
  rescue Errno::ESRCH
    false
  end
end # def

def on_minute?
  now = Time.new
  sec = now.strftime("%-S").to_i
  sec < 5
end # def

def on_min?(num)
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i
  on_minute? && ((min % num) == 0)
end
def on_5th_minute?
  on_min?(5)
end # def

def on_15th_minute?
  on_min?(15)
end # def

def reboot_time?
  now = Time.new
  min = now.strftime("%-M").to_i
  hour24   = now.strftime("%-H").to_i
  hour24 == 10 && min == 5
end # def

def on_hour?
  now = Time.new
  min = now.strftime("%-M").to_i
  on_minute? && min == 0
end # def

def sleep_to_hour
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i
  secs_left = (60 - sec) + 1
  mins_left  = 60 - min
  secs_left = 1 if secs_left < 1
  mins_left = 0 if mins_left < 1
  sleep(secs_left + (60 * mins_left))
end # def

def sleep_to_min(count = 1)
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i

  secs_left = (60 - sec) + 1

  sleep(secs_left)

  if min < 55
    count = 1
  end
  mins_left = 60 * (count - 1)
  sleep( 60 * mins_left) if mins_left > 0
end # def

def sleep_to_30
  now = Time.new
  sec = now.strftime("%-S").to_i
  if sec < 30
    sleep(30 - sec + 1)
  else
    sleep(60 - sec + 1)
  end
end # def

def auto_reboot
  pid = Process.pid
  fork {
    puts "=== Starting forked process: #{Process.pid}"
    while process?(pid)
      if Alegria::Auto_Reboot.yes?
        sleep 60
        Alegria::Auto_Reboot.now!
      end
      sleep_to_min
    end
    puts "=== Done forked process: #{Process.pid}"
  }
end # def auto_reboot

def auto_git_pull
  pid = Process.pid
  fork do
    puts "=== Starting forked process: #{Process.pid}"
    while process?(pid)
      fork do
        system '/apps/alegria/sh/run pull'
        File.write('/tmp/lobby.pull.txt', Time.now.to_s)
      end
      sleep 120
      sleep_to_hour
    end
    puts "=== Done forked process: #{Process.pid}"
  end
end

def auto_hide_cursor
  pid = Process.pid
  fork do
    puts "=== Starting forked process: #{Process.pid}"
    while process?(pid)
      hide_mouse_cursor if on_5th_minute?
      sleep_to_min
    end
    puts "=== Done forked process: #{Process.pid}"
  end
end

class Alegria

  def self.git_commit_hash
    fin = ''
    Dir.chdir('/apps/pictures') do
      fin += `git rev-parse --short HEAD`.strip
    end
    Dir.chdir('/apps/alegria') do
      fin += `git rev-parse --short HEAD`.strip
    end
    fin
  end

  def self.before_hour?(hour)
    return false if Time.now.min == 59 && hour12 == (hour - 1)
    hour12 < hour
  end

  def self.hour12
    Time.new.strftime("%-I").to_i
  end

  def self.closed?
    !open?
  end # def

  def self.open?
    return true

    now    = Time.new
    day    = now.strftime("%a")
    hour24 = now.strftime("%-H").to_i
    hour12 = now.strftime("%-I").to_i

    return false if hour24 < 11
    return true if hour24 >= 11 && hour24 < 19

    # case day
    # when "Fri", "Sat"
    #   before_hour? 9
    # when "Sun"
    #   before_hour? 4
    # else
      # before_hour? 3
    # end # case

  end # def

  def self.tues_after4pm?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && day == "Tue" && hour12 >= 4
  end # def

  def self.wed_after4pm?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && day == "Wed" && hour12 >= 4
  end # def

  def self.kids_special?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && (day == "Tue" || day == "Wed") && hour12 >= 4
  end # def

  def self.closed?
    !open?
  end # def

  def self.stroganoff_special?
    day    = Time.new.strftime("%a")
    open? && (day == "Mon")
  end # def

  def self.pcmanfm_wallpaper(raw_photo)
    new_photo = File.expand_path(raw_photo)
    # if !(new_photo.index(Dir.pwd) == 0)
    #  raise "invalid image path: #{new_photo.inspect}"
    # end

    full_path = new_photo
    STDERR.puts "=== Updating background to: #{full_path}"
    `pcmanfm --set-wallpaper "#{full_path}" --wallpaper-mode=fit`
    true
  end # def

  def self.pcmanfm_desktop_off
    `pcmanfm --desktop-off`
  end

  def self.feh_bg_center(*args)
    `feh --bg-center #{ args.map { |str| File.expand_path(str).inspect }.join(" ") }`
  end

  class Auto_Reboot
    @@last_msg = ""
    CACHE_FILE = "reboot.request.txt"
    class << self

      def now!
        @@last_msg = latest
        `git pull`
        `sudo reboot`
      end # def now!

      def latest
        "Ignore" # File.read(CACHE_FILE)
      end

      def yes?
        @@last_msg == latest || reboot_time?
      end

      def reboot_time?
        now = Time.new
        min = now.strftime("%-M").to_i
        hour24 = now.strftime("%-H").to_i
        hour24 == 6 && min == 5
      end # def
    end # class
  end # class Auto_Reboot

end # class

if $PROGRAM_NAME == __FILE__
  cmd = ARGV.join(' ')
  case cmd
  when 'check'
    puts Alegria.git_commit_hash
  else
    warn "!!! Unknown command: #{cmd}"
    exit 1
  end
end # if
