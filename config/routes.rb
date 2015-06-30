Rails.application.routes.draw do

    get '/' => 'static_pages#index', as: 'root'
    get '/groups' => 'static_pages#groups'
    get '/groups/:id' => 'static_pages#group', as: 'group'
    get '/following' => 'static_pages#following'

    post '/api/users/' => 'users#user_search'
    post '/api/non_admins/' => 'admins#admin_search'

    # sessions
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    post '/logout' => 'sessions#destroy'

    # users
    get '/register' => 'users#new'
    post '/register' => 'users#create'

    get '/settings' => 'users#edit'
    patch '/settings' => 'users#update'

    get '/user/:username' => 'users#show', as: 'show_user'
    get '/user/:username/followers' => 'users#show_followers', as: 'show_user_followers'
    get '/user/:username/following' => 'users#show_following', as: 'show_user_following'
    post '/user/:username/toggle_follow' => 'users#toggle_follow', as: 'toggle_follow_user'

    #admin
    get '/admin' => 'admins#show'
    post '/admin' => 'admins#add_admin'
    post '/admin/:id' => 'admins#delete_admin', as: 'delete_admin'
    
    # groups
    get '/user/:username/groups' => 'groups#show_all', as: 'show_user_groups'
    post '/user/:username/groups' => 'groups#create'
    get '/group/:id' => 'groups#show', as: 'show_group'
    get '/group/:id/members' => 'groups#show_members', as: 'show_group_members'
    post '/group/:id/members' => 'groups#invite_members', as: 'invite_group_members'
    post '/group/:id/accept_invite' => 'groups#accept_invite', as: 'accept_group_invite'
    post '/group/:id/decline_invite' => 'groups#decline_invite', as: 'decline_group_invite'
    post '/group/:id/remove_member' => 'groups#remove_member', as: 'remove_group_member'
    post '/group/:id/leave' => 'groups#leave_group', as: 'leave_group'
    post '/group/:id/disband' => 'groups#disband_group', as: 'disband_group'

    # snippets
    get '/add' => 'snippets#new'
    post '/add' => 'snippets#create'

    get '/snippet/:id' => 'snippets#show', as: 'show_snippet'
    post '/snippet/:id' => 'snippets#edit'

    get '/snippet/:id/edit' => 'snippets#edit'
    post '/snippet/:id/edit' => 'snippets#edit', as: 'edit_snippet'
    patch '/snippet/:id/edit' => 'snippets#update', as: 'update_snippet'

    delete '/snippet/:id' => 'snippets#destroy', as: 'delete_snippet'

    get '/snippet/:id/:file_id' => 'snippets#download_raw', as: 'raw_snippet_file'
  
    #search
    post '/search' => 'snippets#search'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
