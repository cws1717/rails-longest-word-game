require 'open-uri'
require 'json'


class GamesController < ApplicationController

  def new
    letter = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << letter.sample
    end
    # @letters = @letters.join(" ")
  end

  def score
    @word = params[:word].downcase
    @letterkey = params[:letter_field].downcase
    @letterkey = @letterkey.split
    #check if english
    @english = english?(@word)
    @valid = in_grid?(@word, @letterkey)
    if @english == true && @valid == true
      @result = 1
      @score = getscore(@word)
    elsif @english == true && @valid == false
      @result = 2
      @score = 0
    else
      @result = 3
      @score = 0
    end
  end

  def english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.parse(url).read
    word = JSON.parse(word_serialized)
    if word['found'] == true
      true
    else
      false
    end
  end

  def in_grid?(attempt, grid)
    attempt = attempt.chars
    grid_hash = Hash.new(0)
    grid.each { |letter| grid_hash[letter] += 1 }

    attempt_hash = Hash.new(0)
    attempt.each { |letter| attempt_hash[letter] += 1 }
    attempt_hash.each do |key, _value|
      return false if attempt_hash[key] > grid_hash[key]
    end
    return true
  end

  def getscore(attempt)
    attempt = attempt.chars
    numb_of_let = attempt.count
    return numb_of_let ** numb_of_let
  end

end
