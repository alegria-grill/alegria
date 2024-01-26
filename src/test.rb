
require "./src/File_Loop"

ext  = %( -type f -iname '*.mp4' -or -iname '*.mkv' )
office = File_Loop.new(%( find "/home/pi/Videos/mr_safety" -maxdepth 1 #{ext} ))
office.list.each { |x| puts x }
