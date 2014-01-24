class Application < Sinatra::Application

  # Display the requested banner.
  # Because the banners themselves aren't changing with time,
  # the response should be cacheable.
  get '/banners/:banner_id' do |banner_id|
    banner = get_banner(banner_id)
    halt 404 unless banner # Not Found
    # For now every banner is an image which we just send back,
    # but it can be easily extended to serve other types of banners.
    filepath = File.join(settings.public_folder, "images", banner.filename)
    # Note: this will send Last-Modified header set to file's mtime
    send_file filepath, :type => :png, :disposition => :inline
  end

  private

  def get_banner(banner_id)
    Banner.get_by_id(banner_id.to_i) if banner_id =~ /^\d+$/
  end

end
