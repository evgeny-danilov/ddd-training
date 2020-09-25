Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount RailsEventStore::Browser => '/res' if Rails.env.development?

  resource :seat_reservation do
    get :new
    post :reserve
    get :user_input
    post :create_passenger
    get :payment_confirm
    post :payment_done
    get :congratulate
  end
  
end
