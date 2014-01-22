# Public: Simple class representing Banner model.
class Banner

  attr_accessor :id
  attr_accessor :filename

  # Public: Method is responsible for retrieving a Banner object by its id.
  # It should make a call to the provision database in order to find out whether
  # the requested id exists or not and retrieve the object.
  # For our current purpose it is enough to consider that only banners with ids
  # between 100 and 500 exist and return a simple object.
  def self.get_by_id(id)
    return nil unless id.between?(100, 500)
    obj = Banner.new
    obj.id = id
    obj.filename = "image_#{id}.png"
    obj
  end

end
