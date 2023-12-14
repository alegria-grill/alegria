# frozen_string_literal: true

require 'date'

class File_Loop
  attr_reader :i, :list, :cmd

  MONTHS = Date::ABBR_MONTHNAMES.map { |x| x && x.upcase }
  HUMAN_DATE_PATTERN = /[a-z]{3,4}_\d{2}_\d{4}(_\d{2}_\d{2})?\..{1,4}$/i.freeze

  class << self
    def month_name_to_month_number(str)
      i = File_Loop::MONTHS.index(str.upcase) || 0
      return "0#{i}" if i < 10

      i
    end

    def date_string_to_number(s)
      result = s.upcase[HUMAN_DATE_PATTERN]
      return nil unless result

      s_month, s_day, s_year, s_hr, s_min = result.split('.').first.split('_')
      i_month = month_name_to_month_number(s_month)
      "#{s_year}#{i_month}#{s_day}#{s_hr || '00'}#{s_min || '00'}".to_i
    end

    def has_date_ending?(str)
      !!str[HUMAN_DATE_PATTERN]
    end

    def get_files(s_cmd)
      today = File_Loop.date_string_to_number("#{Time.now.strftime('%b_%d_%Y_%H_%M')}.now")
      `#{s_cmd}`.strip.split("\n").select do |file|
        f_number = File_Loop.date_string_to_number(file)
        f_number ? (today < f_number) : true
      end
    end
  end # class self

  def initialize(cmd)
    @i = 0
    @cmd = cmd
    @list = self.class.get_files(cmd)
  end # def

  def next
    return nil if @list.empty?

    photo = @list[@i]
    @i += 1
    if end?
      @list = self.class.get_files(@cmd)
      @i = 0
    end
    photo
  end

  def length
    @list.length
  end

  def last_index
    @list.size - 1
  end

  def start?
    @i.zero?
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
