#!/usr/bin/env ruby
TMP_FILE = '/tmp/time.sign.svg'
TEMPLATE = '/apps/alegria/templates/time.svg'

NOW = Time.now

new_cmd = ARGV.join ' '
case new_cmd

when 'update'
  new_content = File.read(TEMPLATE)
    .sub('!Month', NOW.strftime('%B'))
    .sub('!Day', NOW.strftime('%-d'))
    .sub('!DayName', NOW.strftime('%A'))
    .sub('!H', NOW.strftime('%-I'))
    .sub('!M', NOW.strftime('%M %P'))

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
