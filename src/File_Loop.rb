
require 'date'

class File_Loop
  attr_reader :i, :list

  MONTHS = Date::ABBR_MONTHNAMES.map { |x| x && x.upcase }
  HUMAN_DATE_PATTERN = /[a-z]{3,4}_[\d]{2}_[\d]{4}\..{1,4}$/i

  class << self
    def month_name_to_month_number(s)
      i = File_Loop::MONTHS.index(s.upcase) || 0

      return "0#{i}"  if i < 10
      i
    end

    def date_string_to_number(s)
      result = s.upcase[HUMAN_DATE_PATTERN]
      return nil unless result
      s_month, s_day, s_year = result.split(".").first.split("_")
      i_month = month_name_to_month_number(s_month)
      "#{s_year}#{i_month}#{s_day}".to_i
    end

    def has_date_ending?(s)
      !!s[HUMAN_DATE_PATTERN]
    end
  end # class self

  def initialize(cmd)
    @i = 0
    today = File_Loop.date_string_to_number(Time.now.strftime("%b_%d_%Y") + ".now")
    @list = `#{cmd}`.strip.split("\n").select { |file|
      f_number = File_Loop.date_string_to_number(file)
      if f_number
        today < f_number
      else
        true
      end
    }
  end # def

  def next
    return nil if @list.empty?
    photo = @list[@i]
    @i += 1
    @i = 0 if @i > (@list.size - 1)
    photo
  end

  def length
    @list.length
  end

  def last_index
    @list.size - 1
  end

  def end?
    @i >= last_index
  end

  def current
    @list[@i]
  end

  def nth?(num)
    (@i % num).zero?
  end
end # class
