require 'handy_form'
require 'rails'

module HandyForm
  class Railtie < Rails::Railtie
    initializer "handy_form.initializer" do |app|
      ::ActionView::Base.class_eval do
        include HandyForm::Helpers
      end
    end

    rake_tasks do
      load "handy_form/tasks.rake"
    end
  end
end
