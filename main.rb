require 'bundler/setup'
require 'sinatra'
require 'redis'
require 'sidekiq'
require 'sidekiq/api'


# redis, sidekiq configuration
# NOTE: number of connection is limited to 20 for Hobby Dev heroku-redis

$redis = Redis.new(url: ENV['REDIS_URL'], size: 1)

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], size: 1 }
end

Sidekiq.configure_server do |config|
  # size must be at least #(concurrency of sidekiq server) + 5 + 2
  config.redis = { url: ENV['REDIS_URL'], size: 8}
end


# sidekiq worker

class SinatraWorker
  include Sidekiq::Worker

  def perform(msg="lulz you forgot a msg!")
    sleep msg.length
    $redis.lpush("sinkiq-example-messages", msg)
  end
end


# sinatra app

get '/' do
  stats = Sidekiq::Stats.new
  workers = Sidekiq::Workers.new
  @failed = stats.failed
  @processed = stats.processed
  @working = workers.size
  @messages = $redis.lrange('sinkiq-example-messages', 0, -1)
  erb :index
end

post '/msg' do
  SinatraWorker.perform_async params[:msg]
  redirect to('/')
end


# templates

__END__

@@ layout
<html>
  <head>
    <title>Sinatra + Sidekiq</title>
    <body>
      <%= yield %>
    </body>
</html>

@@ index
  <h1>Sinatra + Sidekiq Example</h1>
  <h2>Failed: <%= @failed %></h2>
  <h2>Working: <%= @working %></h2>
  <h2>Processed: <%= @processed %></h2>

  <form method="post" action="/msg">
    <input type="text" name="msg">
    <input type="submit" value="Add Message">
  </form>

  <a href="/">Refresh page</a>

  <h3>Messages</h3>
  <% @messages.each do |msg| %>
    <p><%= msg %></p>
  <% end %>
