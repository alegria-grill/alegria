# frozen_string_literal: true

class AV
  class << self
    def play_video(str_src)
      system %(mpv --sub-auto=fuzzy --fullscreen "#{src}")
    end

    def volume_to(str_or_num)
      system %(amixer set Master #{str_or_num}%)
      set 1
    end
  end # class << self
end # class
