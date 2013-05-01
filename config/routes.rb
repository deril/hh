Hh::Application.routes.draw do

  # TODO: root !!!
  # TODO: front !!!
  # TODO: alert notice in layout

  # TODO: may be ruby 1.8
  # TODO: add logining for admin
  # TODO: notification
  # TODO: some bad idea /:page

  get "images/:page" => "images#index", as: "images_list"
  resources :images, only: [:index, :show]

  get "tag/:id/:page" => "images#images_by_tag", as: "by_tag_with_page"
  resources :tags, only: [:index, :show]

  resources :dispatch_tags, exept: [:edit]
  get "dispatch_tags/page/:page" => "dispatch_tags#index", as: "dispatch_tags_with_page"

  resources :dispatch_imgs, exept: [:show, :update]
  # get "dispatch_imgs/page/:page" => "dispatch_imgs#index", as: "dispatch_imgs_with_page"

  get "stack" => "dispatch_imgs#images_from_dir"
  post "stack" => "dispatch_imgs#saving_from_dir"
  
  get 'paginate_tags' => "dispatch_imgs#paginate_tags"

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
  # match ':controller(/:action(/:id))(.:format)'
end
