require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController

  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  post '/songs' do
    @artist = Artist.find_by(name: params[:artist_name])
    if @artist == nil
      @artist = Artist.create(name: params[:artist_name])
    end
	    @song = Song.new(name: params[:song_name])
	    @song.artist = @artist
	    @song.genre_ids = params[:genres]
	    @song.save
	    flash[:message] = "Successfully created song."
	    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  patch '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @song.artist.update(name: params[:artist_name])
    @song.genre_ids = params[:genres]
    @song.save
    flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end


end