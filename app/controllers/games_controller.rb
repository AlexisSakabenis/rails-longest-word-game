require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }.join(' ')
  end

  def score
    @word = params[:word]
    @letters = params[:letters] || ''
    @can_be_built = true

    if @word.present?
      @word.chars.each do |letter|
        if @word.count(letter) > @letters.count(letter)
          @result = "The word can't be built"
          next
        end
      end
    end

    if @can_be_built
      url = URI.parse("https://wagon-dictionary.herokuapp.com/#{@word}")
      response = Net::HTTP.get_response(url)
      json = JSON.parse(response.body)
      puts json
      if json['found'] == true
        @result = 'The word is valid and it is in english'
      else
        @result = 'The word is valid but it is not english'
      end
    end
  end
end
