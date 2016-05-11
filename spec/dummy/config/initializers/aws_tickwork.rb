require 'aws_tickwork'

AwsTickwork::Engine.setup do |c|
#  c.https_only = true
#  c.http_username = 'john'
#  or an MD5 Digest::MD5.hexdigest(["aws", AwsTickwork::REALM, 'password'].join(":"))
#  c.http_password = 'password'
end

