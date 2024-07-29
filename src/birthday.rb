#!/usr/bin/env ruby

new_content = File.read('/tmp/birthday.svg')
.sub('MONTH', 'July')
 .sub('DD!', '29');

names = ["John Down\n", "Jane Fdere", "Booy dsdf"]
5.times do |i|
  new_content = new_content.sub("Person#{i+1}", names.shift || '')
end

File.write('/tmp/new.svg', new_content);

