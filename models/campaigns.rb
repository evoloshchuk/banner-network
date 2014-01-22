require 'redis'
require 'redis/objects'

# Public: Simple class representing Campaign model.
class Campaign

  include Redis::Objects

  attr_accessor :id
  set :banner_ids # stored in redis

  # Public: Method is responsible for retrieving a Campaign object by its id.
  # It should make a call to the provision database in order to find out whether
  # the requested id exists or not and retrieve the object.
  # For our current purpose it is enough to consider that only banners with ids
  # between 1 and 50 exist and return a simple object.
  def self.get_by_id(id)
    return nil unless id.between?(1, 50)
    obj = Campaign.new
    obj.id = id
    obj
  end

  # Public: Returns a banner id to be displayed for the current campaign.
  def get_banner_id(excluded_banner_id=nil)
    begin
      # This should never happen in a normal circumstances,
      # only when there is no data processed yet.
      return nil if banner_ids.empty?
      target_banner_ids = banner_ids.members.map { |el| el.to_i }
      if excluded_banner_id and target_banner_ids.length > 1
        target_banner_ids = target_banner_ids - [excluded_banner_id]
      end
      target_banner_ids.sample
    rescue Exception => e
      # Something went wrong while talking to redis.
      # TODO: retry?
      nil
    end
  end

  # Public: Saves the available banners for campaign
  def update(ids)
    banner_ids << ids
  end

end
