Rails.application.routes.draw do
  root to: 'report#show'

  mount Comparison::Engine => "/comparison"
end
