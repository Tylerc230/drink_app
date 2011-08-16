#!/usr/bin/ruby
require 'optparse'
require 'net/http'

def do_login(token)
  send_post("user_sessions", {'token' => token})
end

def do_cheers(fbid)
  send_post("cheers", {'fbid' => fbid})
end


def send_post(controller, params)
    puts "#{controller} params: #{params.to_s}"
	url = URI.parse("http://localhost:3000/#{controller}")
	res = Net::HTTP.post_form(url, params)
	puts res.body
end

options = {}
OptionParser.new do |opts|

	options[:test] = nil
	opts.on('-t', '--test TEST', 'Test to run') do |test|
		options[:test] = test
	end

	options[:token] = "IP4fWh9uCW22BAYeG2fQXwKQ463rYVYa3mZvY2VCsLs.eyJpdiI6IlpBYlRpNFRKT3d0dHlkQzQyTklNVEEifQ.pgrQQM1EixbZZSJ_HfTpHXToI6g32Pjb49zc_ZBgsZ_MtIBIf2CfQpBv3INLje-AN91ohK8zB5hb2hV3MxQkAHTplvZSK7ec-N1-VjmsTfVofcLUhcH1Da4qQtdSPp8qkwLiZ548cCh3CyroOFE1xw"
	opts.on( '-k', '--token TOKEN', 'Facebook token') do |token|
		options[:token] = token
	end

    options[:fbid] = 100000772935393
    opts.on('-f', '--fbid FBID', 'Facebook Id') do |fbid|
      options[:fbid] = fbid
    end

	opts.on( '-h', '--help', 'Display this screen' ) do
		puts opts
		exit
	end
end.parse!

test =  options[:test]

case test
	when "login"
		token = options[:token]
		do_login token
	when "checkin"
		puts "checking in"
    when "cheers"
        fbid = options[:fbid]
        do_cheers fbid
	else
		puts "need test"
end


