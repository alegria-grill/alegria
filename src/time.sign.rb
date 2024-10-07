#!/usr/bin/env ruby
# frozen_string_literal: true

TMP_FILE = '/tmp/time.sign.svg'
TEMPLATE = '/apps/pictures/templates/time.svg'

NOW = Time.now

new_cmd = ARGV.join ' '
case new_cmd

when 'update'
  new_content = File.read(TEMPLATE)
    .gsub('!Month', NOW.strftime('%B'))
    .gsub('!DayName', NOW.strftime('%A'))
    .gsub('!Day', NOW.strftime('%-d'))
    .gsub('!H', NOW.strftime('%-I'))
    .gsub('!M', NOW.strftime('%M %P'))

  File.write(
    TMP_FILE,
    new_content
  )
  puts 'Updated time sign to read'
  puts "File: #{TMP_FILE}"

else
  warn "!!! Unknown arguments: #{new_cmd.inspect}"
  exit 1

end # case
