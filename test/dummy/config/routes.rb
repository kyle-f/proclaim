Rails.application.routes.draw do
  mount Bespoke::Engine => "/bespoke"

  root 'posts#index'
end
