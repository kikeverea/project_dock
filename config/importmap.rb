# Pin npm packages by running ./bin/importmap

pin "application"
#pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" # @2.1.0
#pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
#pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.11

pin_all_from "app/javascript/controllers", under: "controllers"
pin "tom-select", to: "tom-select.js" # @2.6.0
