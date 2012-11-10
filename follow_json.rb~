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

$target = YAML.load_file "target.yaml"

client = Twitter::Client.new(:consumer_key => consumer['key'],
                         :consumer_secret => consumer['secret'],
                         :oauth_token => access['token'],
                         :oauth_token_secret => access['secret'])

CONTINUATION = "crawl_continue.json"
if File.exist?(CONTINUATION)
  json = JSON.parse(File.read(CONTINUATION))
  $lists          = json["lists"]
  $result         = json["result"]
end

LIST_FILE = "list.json"
if $lists.empty? and File.exist?(LIST_FILE)
  $lists = JSON.parse(File.read(LIST_FILE))
end
if $lists.empty?
  result = client.lists($target)
  $lists = result.map(&:slug)
  File.open(LIST_FILE, 'w') do |f|
    f.write($lists.to_json)
  end
  puts "newly loaded list"
end

pp $result
loop do
  begin
    until $lists.empty?
      list = $lists.shift
      cursor = -1
      loop do
        $result[list] ||= []
        cursor = client.list_members $target, list, {:cursor => cursor}
        $result[list] += cursor.map &:screen_name
        break if cursor.last?
      end
      $result[list].uniq!
      puts "#{list} => $result[list]"
    end
  ensure
    File.open(CONTINUATION, "w") do |f|
      f.write({"lists"=>$lists, "result"=>$result}.to_json)
    end
    RESULT = "result.json"
    File.open(RESULT, 'w') do |f|
      f.write($result.to_json)
    end
  end
  sleep 30*60
end
