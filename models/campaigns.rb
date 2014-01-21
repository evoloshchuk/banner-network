# encoding: utf-8

require 'redis'
require 'redis/objects'

# Simple class representing Campaign model.
class Campaign

  include Redis::Objects

  attr_accessor :id
  set :banner_ids # stored in redis

  # This method is responsible for retrieving a Campaign object by its id.
  # It should make a call to the provision database in order to find out whether
  # the requested id exists or not and retrieve the object.
  # For our current purpose it is enough to consider that only banners with ids
  # between 1 and 50 exist and return a simple object.
  def self.get_by_id(id)
    if id.between?(1, 50)
      obj = Campaign.new
      obj.id = id
      obj
    else
      nil
    end
  end

  # Returns a banner id to be displayed for the current campaign.
  def get_banner_id
    begin
      if banner_ids.empty?
        # This should never happen in a normal circumstances,
        # only when there is no data processed yet.
        nil
      else
        # Latest 0.8.0 version of redis-object does not yet include already
        # implemented method Redis::Set:randmember, so let do it ourselves.
        banner_ids.members.sample.to_i
      end
    rescue Exception => e
      # Something went wrong while talking to redis.
      # TODO: retry?
      nil
    end
  end

  # Saves the available banners for campaign
  def update(ids)
    banner_ids << ids
  end

end
