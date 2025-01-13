#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

module Birthday_Sign
  extend self

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
      content = content.sub(%(id="#{id}"), %(id="#{id}" style="opacity:0.50"))
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
