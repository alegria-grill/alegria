
LAST_ACCIDENT_TXT = "data/last.accident.timestamp"
TEMPLATES_ACCIDENT = "templates/accident.svg"
IMAGES_ACCIDENT = "images/accident.svg"
NOW_TS = Time.now.to_i
NOW = Time.now
TODAY = Time.new(NOW.year, NOW.month, NOW.day, 0, 0, 0)

new_cmd = ARGV.join " "
case new_cmd
when "reset"
  File.write(LAST_ACCIDENT_TXT, NOW_TS.to_s)
when /write\ +\d+/
  days = ARGV[1].to_i
  new_ts = TODAY.to_i - (24 * 60 * 60 * days)
  File.write(LAST_ACCIDENT_TXT, new_ts)
when "update"
  new_count = begin
                secs = Time.now.to_i - File.read(LAST_ACCIDENT_TXT).to_i
                days = (secs/60/60/24).to_i
                (days < 1) ? 0 : days
              end
  File.write(
    IMAGES_ACCIDENT,
    File.read(TEMPLATES_ACCIDENT).sub("!DAYS", new_count.to_s)
  )
  puts "Updated sign to read: #{new_count} days"
else
  STDERR.puts "!!! Unknown arguments: #{new_cmd.inspect}"
  exit 1
end

