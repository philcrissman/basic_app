run "rm public/index.html"


gem 'sevenwire-forgery', :lib => 'forgery', :source => 'http://gems.github.com'
gem 'thoughtbot-shoulda', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'shoulda', :source => 'http://gems.github.com'
gem 'authlogic'
gem 'cancan'
gem 'formtastic'

rake "gems:install"
rake "gems:unpack"

plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
plugin 'fast_context', :git => 'git://github.com/lifo/fast_context.git'


generate(:session, 'user_session')
generate(:model, 
  'user',
  'login:string',
  'email:string',
  'first_name:string',
  'last_name:string',
  'crypted_password:string',
  'password:string',
  'persistence_token:string',
  'single_access_token:string',
  'perishable_token:string',
  'login_count:integer',
  'failed_login_count:integer',
  'last_request_at:datetime',
  'current_login_at:datetime',
  'last_login_at:datetime',
  'current_login_ip:string',
  'last_login_ip:string')
generate(:controller, 'user_sessions', 'new', 'create', 'destroy')
generate(:controller, 'users', 'index', 'show', 'new', 'create', 'edit', 'update', 'destroy')
generate(:controller, 'password_resets', 'new', 'create', 'edit', 'update')

route "map.resource :user_session"
route "map.resources :users"
route "map.root :controller => 'users', :action => 'index'"
route "map.resources :password_resets"

rake "db:create"
rake "db:migrate"

file ".gitignore", <<-END
  .DS_Store
  log/*.log
  tmp/**/*
  config/database.yml
  db/*.sqlite3
  README
  public/index.html
END

run "touch app/views/layouts/minimal.html.erb"
run "touch test/factories.rb"
run "cp ~/Projects/templates/basic_app/application_controller.rb app/controllers/application_controller.rb"
run "cp ~/Projects/templates/basic_app/test_helper.rb test/test_helper.rb"
run "mkdir test/shoulda_macros"
run "cp -R ~/Projects/templates/basic_app/shoulda_macros/ test/shoulda_macros/"

run "cp ~/Projects/templates/basic_app/user_sessions_controller.rb app/controllers/user_sessions_controller.rb"
run "cp ~/Projects/templates/basic_app/users_controller.rb app/controllers/users_controller.rb"
run "cp ~/Projects/templates/basic_app/password_resets_controller.rb app/controllers/password_resets_controller.rb"

run "cp config/database.yml config/example_database.yml"

git :init

git :add => "."
git :commit => "-a -m 'initial commit'"
