Rails.application.routes.draw do

  mount AwsTickwork::Engine => "/aws_tickwork"
end
