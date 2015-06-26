Rails.application.routes.draw do

  root 'main#home'
  get '/about' => 'main#about'
  post '/create' => 'main#create'
  
end
