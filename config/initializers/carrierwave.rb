CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAIPWG3CCQNAKATBLQ',
    :aws_secret_access_key  => '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'
  }
  config.fog_directory  = "curarium_uploads"
end

=begin
CarrierWave.configure do |config|
  
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  else
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key:  ENV["AWS_SECRET_ACCESS_KEY"]
    }
    config.fog_directory  = "curarium_uploads"
  end
end
=end