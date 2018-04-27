require "sinatra"
require "sinatra/activerecord"
require_relative './models/user'
require_relative './models/taggedpost'
require_relative './models/tag'
require_relative './models/post'

set :database, {adapter: 'postgresql', database: 'rumblr', username: 'postgres', password: 'ronen1983'}
enable :sessions
#Be aware there is the issue with sessions and shotgun/reloader, since they reload our app everytime
#Apparently doing something like : set :session_secret, "password_security" fixs it?
#Not sure why yet.
get '/' do
    erb :index
end

get '/users/home' do
  erb :'/users/home'
end


get '/registrations/signup' do
    erb :'/registrations/signup'
end

get '/sessions/login' do
    erb :'/sessions/login'
end

get '/profile/:id' do
  @user = User.find(session[:id])
    erb :profile
end



get '/logout' do
    #Clear all sessions
    session.clear
    #You can also just set the session to nil like this : session[:id] = nil
    redirect '/'
end

post '/sessions/login' do
    @user = User.find_by(user_name: params[:user_name], password: params[:password])
    if @user != nil
        session[:id] = @user.id
        redirect "/profile/#{:id}"


    else

      erb :'/registrations/signup',  locals: {message: "Invalid user or password. Please try again."}
        #Could not find this user. Redirecting them to the signup page
    end
end




  post '/registrations/signup' do
    #Creating a new user based on the values from the form
    @newuser = User.create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password], birthday: params[:birthday], user_name: params[:user_name])
    #Setting the session with key of ID to be equal to the users id
    #Essentialy this "Logs them in"
    session[:id] = @newuser.id
    redirect "/profile/#{:id}"
end


get '/profile/:id/edit' do
  @user = User.find(params[:id])
  erb :'/users/edit'
end

put '/profile/:id' do
@user = User.find(params[:id])
@user.update(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], password: params[:password], birthday: params[:birthday], user_name: params[:user_name])
  redirect "/profile/:id"
end

delete '/profile/:id' do
User.destroy(params[:id])
redirect '/'
end




get '/users/blogpage' do
  @posts = Post.all

  erb :'/users/blogpage'
end

get '/posts/new' do
  erb :'/posts/new'
end


post '/posts/new' do
  #Creating a new user based on the values from the form
  @newpost = Post.new(params[:post])
  @newpost.user_id = current_user.id
  @newpost.save
  @newpost.tags.create(name: params[:tag][:name])

  redirect "/users/blogpage"
end

get '/posts/:id/edit' do
  @editpost = Post.find(params[:id])
  erb :'/posts/edit'
end

put '/posts/:id' do
@editpost = Post.find(params[:id])
@editpost.update(title: params[:title], content: params[:content])
@editpost.tags.update(name: params[:tag][:name])


  redirect "/users/blogpage"
end

delete '/posts/:id' do
Post.destroy(params[:id])
redirect '/users/blogpage'
end


private
#Potentially useful function instead of checking if the user exists
def user_exists?
    (session[:id] != nil) ? true : false
end

def current_user
    User.find(session[:id])
end
