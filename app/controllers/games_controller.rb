require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    9.times { @letters << [*('A'..'Z')].sample }
    @letters << ["A", "E", "I", "O", "U"].sample
  end

  def valid_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    dictionary_serialized = URI.open(url).read
    JSON.parse(dictionary_serialized)
  end

  def matching
    @word.chars.all? { |letter| @word.chars.count(letter) <= @letters.count(letter) }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:grid]
    @valid_word = valid_word
    @matching = matching
    @message = ''
    if !@matching
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters.gsub(" ", ", ")}"
    elsif @valid_word == false
      @message = "Sorry but #{@word.upcase} does not appear to be a valid English word"
    else
      @message = "Congratulations! #{@word} is a valid English word!"
    end
    return @message
  end
end
