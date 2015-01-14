# see: http://blog.sorryapp.com/2013/03/22/request-and-controller-specs-with-devise.html

module ValidUserRequestHelper
  def session
    s = last_request.env[ 'rack.session' ]
    s[ :browserid_email ] = User.first.email
    s
  end
end

RSpec.configure do |c|
  c.include ValidUserRequestHelper, :type => :request
end

     
