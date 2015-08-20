require 'sinatra'
require_relative 'parser_servise'

#ugly store to help emulate REST routing if no db storage used
$accounts = nil

get '/' do
  haml :index
end

get '/accounts' do
  redirect '/' unless $accounts
  haml :accounts, locals: {accounts: $accounts}
end

post '/parse' do
  $accounts = ParserService.new.run(params[:path])
  redirect '/accounts'
end
