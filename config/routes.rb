FoodPacker::Application.routes.draw do
  
  match 'user/edit' => 'users#edit', :as => :edit_current_user

  match 'signup' => 'users#new', :as => :signup

  match 'logout' => 'sessions#destroy', :as => :logout

  match 'login' => 'sessions#new', :as => :login

  resources :sessions

  resources :users

  root :to => 'receipts#index'

  resources :receipts

  resources :products
  
  resources :groups
  
  resources :meals
  
  resources :specials
  
  resources :boxes do
    get 'group/:group_id', :on => :member, :action => 'calculate_box_for_group', as: :calculate_group_box_with
    post 'group_boxes', :on => :collection, :action => 'create_groups_boxes', as: :create_groups
    post 'group_boxes', :on => :member, :action => 'create_group_boxes', as: :create_group
  end
  
  scope "/lists" do
    get '', controller: :lists, action: :index, as: :lists
    get 'products/aggregate', controller: :lists, action: 'products_aggregate', as: :products_aggregate_list
    get 'products/overview', controller: :lists, action: 'products_overview', as: :products_overview_list
    get 'boxes/:box_id/groups', controller: :lists, action: 'products_box', as: :products_box_list
    get 'boxes/:box_id/groups/:group_id', controller: :lists, action: 'products_box_group', as: :products_box_group_list
    get 'boxes/:box_id/products', controller: :lists, action: 'groups_box', as: :groups_box_list
    get 'boxes/:box_id/products/:product_id', controller: :lists, action: 'groups_box_product', as: :groups_box_product_list
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
