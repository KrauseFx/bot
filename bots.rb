require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = ENV["CONSUMER_KEY"]
    self.consumer_secret = ENV["CONSUMER_SECRET"]

    # Users to block instead of interacting with
    self.blacklist = []

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    scheduler.every '1h' do
      model = Ebooks::Model.load("model/tweets.model")
      text = mode.make_statement(140)
      tweet(text)
    end
  end

  def on_message(dm)
    model = Ebooks::Model.load("model/tweets.model")
    # Reply to a DM
    reply(dm, model.make_response(tweet.text, 130))
  end

  def on_follow(user)
    # Follow a user back
    # follow(user.screen_name)
  end

  def on_mention(tweet)
    model = Ebooks::Model.load("model/tweets.model")
    text = model.make_response(tweet.text, 130)
    reply(tweet, meta(tweet).reply_prefix + text)
  end

  def on_timeline(tweet)
    model = Ebooks::Model.load("model/tweets.model")
    unless tweet.text.include?("@") # we don't want to take part at other conversations
      text = model.make_response(tweet.text, 130)
      reply(tweet, meta(tweet).reply_prefix + text)
    end
  end

  def on_favorite(user, tweet)
    # Follow user who just favorited bot's tweet
    # follow(user.screen_name)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("seriouskrausefx") do |bot|
  bot.access_token = ENV["ACCESS_TOKEN"]
  bot.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end
