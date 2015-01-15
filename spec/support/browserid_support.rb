# see: http://blog.sorryapp.com/2013/03/22/request-and-controller-specs-with-devise.html

# this doesn't seem to help get session in request specs
module ValidUserRequestHelper
  def session
    last_request.env[ 'rack.session' ]
  end
end

RSpec.configure do |c|
  c.include ValidUserRequestHelper, :type => :request
end

     
