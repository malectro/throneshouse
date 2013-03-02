class User
  include Mongoid::Document
  include Mongoid::Timestamps

  API_KEY = ENV['TWITTER_API_KEY']
  API_SECRET = ENV['TWITTER_API_SECRET']

  HOUSES = [:stark, :greyjoy, :lannister, :baratheon, :tyrell, :martell]
  HOUSE_LONG_NAMES = {
    stark: "The Starks of Winterfell",
    greyjoy: "The Ironmen of Pyke",
    lannister: "The Lannisters of Casterly Rock",
    baratheon: "The Baratheons of Storm's End",
    tyrell: "The Tyrells of Highgarden",
    martell: "The Martells of Dorne"
  }

  field :house, type: Symbol

  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :token, type: String
  field :secret, type: String

  def house_or_assign_house
    house || assign_house
    :lannister
  end

  def house_long_name
    HOUSE_LONG_NAMES[house_or_assign_house]
  end

  def assign_house
    remaining_houses = HOUSES - User.all.map(&:house)
    update_attributes house: remaining_houses.sample
    house
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
    end
  end

  def self.addurls(urls)
    user.urls = urls
  end

  def self.prepare_access_token(user)
    consumer = OAuth::Consumer.new(API_KEY, API_SECRET, {
      site: "http://www.twitter.com/"
    })

    #token_hash = {:oauth_token => user.token,:oauth_token_secret => user.secret}
    access_token = OAuth::AccessToken.new(consumer, user.token, user.secret)
  end
end

