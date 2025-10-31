#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

module Birthday_Sign
  extend self

  def month_name
    Date.today.strftime("%B").downcase
  end

  def last_tuesday_of_the_month
    today = Date.today

    if today.month == 12
      next_month = 1
      next_year = today.year + 1
    else
      next_month = today.month + 1
      next_year = today.year
    end

    next_first = Date.new(next_year, next_month, 1)
    next_cwday = next_first.cwday
    last_tuesday = case next_cwday
                   when 1
                     next_first - 6
                   when 2
                     next_first - 7
                   else
                     next_first - (next_cwday - 2)
                   end
    last_tuesday
  end # def last_tuesday_of_the_month

  def is_bd_party_over?
    Date.today > last_tuesday_of_the_month
  end

  def show_today?
    today_num = Time.now.day
    body = File.read(current_template_file)
    answer = body[/="day#{today_num}"/]
    return answer if answer

    case Time.now.strftime('%A').upcase
    when 'FRIDAY', 'SATURDAY'
      body[/="day#{today_num + 1}"/] || body[/="day#{today_num + 2}"/]
    else
      answer
    end
  rescue Object => _e
    false
  end

  def current_month
    today = Time.now
    Date::MONTHNAMES[today.month].downcase
  end

  def current_template_file
    "/apps/pictures/templates/birthday.#{current_month}.svg"
  end

  def current_file
    "/tmp/birthday.#{current_month}.svg"
  end

  def generate
    return false unless File.exist?(current_template_file)

    content = File.read(current_template_file)

    (Time.now.day - 1).times do |i|
      id = "day#{i + 1}"
      content = content.sub(%(id="#{id}"), %(id="#{id}" style="opacity:0.40"))
    end # .times

    File.write(current_file, content)
    current_file
  end
end # module

if $PROGRAM_NAME == __FILE__
  cmd = ARGV.join(' ')
  case cmd
  when 'update'
    result = Birthday_Sign.generate
    if result
      puts result
    else
      warn '!!! Something went wrong. File did not generate.'
      exit 1
    end
  else
    warn "!!! Unknown command: #{cmd}"
    exit 1
  end
end # if
