#!/usr/bin/env ruby
# encoding: utf-8

while 2 > 1
  begin
    report = eval(`lighthouse https://www.google.com --disable-device-emulation --disable-network-throttling --perf --quiet --chrome-flags='--headless --no-sandbox' --output=json`)
    puts "google_page_first_render,#{report[:audits][:"first-meaningful-paint"][:name]},#{report[:audits][:"first-meaningful-paint"][:rawValue]},#{report[:audits][:"first-meaningful-paint"][:extendedInfo][:value][:timestamps][:navStart]}"
    puts "google_page_first_interactive,#{report[:audits][:"first-interactive"][:name]},#{report[:audits][:"first-interactive"][:rawValue]},#{report[:audits][:"first-interactive"][:extendedInfo][:value][:timestamp]}"
  rescue
    next
  end
end
