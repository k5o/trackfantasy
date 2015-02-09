AWS::S3::Base.establish_connection!(
  :access_key_id     => ENV["aws_secret_access_key"], 
  :secret_access_key => ENV["aws_secret_key_id"]
)

AWS::S3::DEFAULT_HOST.replace "s3-us-west-1.amazonaws.com"