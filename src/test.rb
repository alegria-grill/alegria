
require "./src/File_Loop"

photo_ext  = %( -type f -iname '*.jpg' -or -iname '*.png' -or -iname '*.heic' )
office     = File_Loop.new(%( find "/apps/slides/exports" -maxdepth 1 #{photo_ext} ))
office.list.each { |x| puts x }
