require "sinatra"
require "sinatra/activerecord"
require_relative './models/user'
require_relative './models/taggedpost'
require_relative './models/tag'
require_relative './models/post'


enable :sessions
#Be aware there is the issue with sessions and shotgun/reloader, since they reload our app everytime
#Apparently doing something like : set :session_secret, "password_security" fixs it?
#Not sure why yet.
get '/' do
    erb :index
end


get '/signup' do
    erb :signup
end

get '/login' do
    erb :login
end

get '/profile/:id' do
  @user = User.find(session[:id])

    erb :profile
end

put '/profile/:id' do
@user = User.find(params[:id])
@user.update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password], birthday: params[:birthday], user_name: params[:user_name])
  redirect "/profile/:id"
end

get '/search' do
  @search = Post.all.order("asc")
  if params[:search]
    @search = Post.search(params[:search])
else
  @search = Post.all
end
erb :search
end

post '/search/:name' do
  @search = Post.where(content: params[:content])
  redirect "/search"
end

get '/searchresults' do
erb :searchlink
end

get '/logout' do
    #Clear all sessions
    session.clear
    #You can also just set the session to nil like this : session[:id] = nil
    redirect '/'
end

post '/login' do
    @user = User.find_by(user_name: params[:user_name], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        redirect "/"
    else
      erb :signup
        #Could not find this user. Redirecting them to the signup page
    end
end




  post '/signup' do
    #Creating a new user based on the values from the form
    @newuser = User.create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password], birthday: params[:birthday], user_name: params[:user_name])
    #Setting the session with key of ID to be equal to the users id
    #Essentialy this "Logs them in"
    session[:id] = @newuser.id
    redirect "/profile/#{:id}"
end


get '/profile/:id/edit' do
  @user = User.find(params[:id])
  erb :edit
end

put '/profile/:id' do
@user = User.find(params[:id])
@user.update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password], birthday: params[:birthday], user_name: params[:user_name])
  redirect "/"
end

delete '/profile/:id' do
User.destroy(params[:id])
redirect '/'
end


get '/blogpage' do
  @posts = Post.all

  erb :blogpage
end

get '/new' do
  if user_exists?
  @tags = Tag.all
  erb :new
else
  redirect "/login"
end
end


post '/new' do
  #Creating a new user based on the values from the form
  @newpost = Post.new(params[:post])
  params[:post][:user_id] = current_user
  @newpost.user_id = current_user.id
  @newpost.save
  @newpost.tags.create(name: params[:tag][:name])
  if !params[:tag][:name].empty?
  @newpost = Tag.new(name: params[:tag][:name])
  end
  redirect "/blogpage"
end

get '/posts/:id/edit' do
  @editpost = Post.find(params[:id])
  erb :editpost
end

put '/posts/:id' do
@editpost = Post.find(params[:id])
@editpost.update(title: params[:title], content: params[:content])
@editpost.tags.update(name: params[:tag][:name])


  redirect "/blogpage"
end

delete '/posts/:id' do
Post.destroy(params[:id])
redirect '/blogpage'
end



  private

  helpers do
      def user_exists?
          (session[:id] != nil) ? true : false
      end

      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end

      def current_user_id
          session[:id]
      end

      def logged_in?
      !!current_user
    end


  end
