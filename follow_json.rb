# -*- coding: utf-8 -*-
require 'yaml'
require 'json'
consumer = YAML.load_file "consumer.yaml"
access = YAML.load_file "access.yaml"
require 'pp'
require "twitter"

$user_list = []
$user_stack = []
$result = {}
$lists = []

$target = JSON.parse(File.read "users.json")
puts $target.size.to_s + " users to follow"
$target.shuffle!

client = Twitter::Client.new(:consumer_key => consumer['key'],
                         :consumer_secret => consumer['secret'],
                         :oauth_token => access['token'],
                         :oauth_token_secret => access['secret'])
$target.each{|t|
  begin
    client.follow(t)
    puts "followed #{t}"
    sleep 5
  rescue => e
    print "declined by twitter"
    sleep 30
    puts " retry!"
    next
  end
}
puts "finish!"
