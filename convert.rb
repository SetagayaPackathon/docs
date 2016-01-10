#!/usr/bin/env ruby

require 'csv'
require 'json'

data = []
csv = CSV.read('./quiz.csv',:headers=>true)
csv.each do |row|
  data.push({
    "question" => row["Text"],
    "choice" => [row["a1"], row["a2"], row["a3"], row["a4"],],
    "answer" => row["a1"]
  })
end

puts 'var questions_data = ' + JSON.pretty_generate(data) + ';'
