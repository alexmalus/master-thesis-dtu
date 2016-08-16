Rails.application.routes.draw do
  # devise_for :users
  # use when you need to add custom logic to these parts of the app
  # this + views moved into users folder in views and then generate controllers for each needed
  devise_for :users, :controllers => { :invitations => 'users/invitations',
  :registrations => "users/registrations" }
  #   :passwords => "users/passwords", ,
  #   :sessions => "users/sessions", :unlocks => "users/unlocks"}

  devise_scope :user do
    get "/login" => "devise/sessions#new", via: [:get, :post]
    # patch "/confirm" => "confirmations#confirm"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root to: 'dashboards#index'
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  resources :messages
  resources :chatrooms, param: :slug

  # project related
  get '/project_summary', to: 'projects#project_summary', as: :project_summary
  get '/projects/artifacts', to: 'projects#artifacts', as: :project_artifacts
  get '/projects/documents', to: 'projects#documents', as: :project_documents
  get '/projects/plan', to: 'projects#plan', as: :project_plan
  get '/projects/story_map', to: 'projects#story_map', as: :project_story_map
  get '/projects/work', to: 'projects#work', as: :project_work
  match "/projects/document_upload" => 'projects#document_upload', via: [:get, :post]
  match "/projects/move_user_story_to_sprint" => 'projects#move_user_story_to_sprint', via: [:get, :post], as: :move_user_story_to_sprint
  get '/projects/move_user_story_to_icebox', to: 'projects#move_user_story_to_icebox', as: :move_user_story_to_icebox
  get '/projects/close_popup', to: 'projects#close_popup'
  match '/projects/create_task', to: 'projects#create_task', via: [:get, :post], as: :create_task
  match '/projects/edit_task', to: 'projects#edit_task', via: [:get, :post], as: :edit_task
  get '/projects/delete_task', to: 'projects#delete_task', as: :delete_task
  match '/projects/transform_to_task', to: 'projects#transform_to_task', via: [:get, :post], as: :transform_to_task
  get '/projects/integrate_user_story', to: 'projects#integrate_user_story', as: :integrate_user_story
  get '/projects/assign_task', to: 'projects#assign_task', as: :assign_task
  get '/projects/resign_task', to: 'projects#resign_task', as: :resign_task
  match '/projects/edit_user_task', to: 'projects#edit_user_task', via: [:get, :post], as: :edit_user_task
  get '/projects/retrospective', to: 'projects#retrospective', as: :project_retrospective
  # TODO future:
  # get '/projects/new_sprint_burndown', to: 'projects#new_sprint_burndown', as: :project_new_sprint_burndown

  # team related
  match "/invite" => 'teams#invite', via: [:get, :post]
  match "/accept_invite" => 'teams#accept_invite', via: [:get, :post]
  match "/refuse_invite" => 'teams#refuse_invite', via: [:get, :post]
  match "/remove_from_team" => 'teams#remove_from_team', via: [:get, :post]
  
  # user related
  match '/show_profile' => 'users#show_profile', via: [:get]
  match '/grant_role' => 'users#grant_role', via: [:get, :post], as: :grant_role
  match '/revoke_role' => 'users#revoke_role', via: [:get, :post], as: :revoke_role

  # admin related
  match '/manage_users' => 'users#manage_users', via: [:get, :post], as: :manage_users

  # dashboard related
  get '/about', to: 'dashboards#about', as: :about
  match "/contact" => "dashboards#contact", via: [:get, :post], as: :contact

  # product backlog related
  get '/product_backlogs/show', to: 'product_backlogs#show', as: :product_backlog_show
  get '/product_backlogs/close_popup', to: 'product_backlogs#close_popup'

  # user stories related

  # namespace :project do
  resources :projects
  resources :epics
  resources :themes
  resources :documents
  resources :sprints
  resources :releases
  resources :sprint_backlogs
  # end
  resources :teams

  resources :user_stories
  resources :retrospectives
end
