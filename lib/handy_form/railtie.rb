require 'handy_form'
require 'rails'

module HandyForm
  class Railtie < Rails::Railtie
    initializer "Handy Form Initializer" do
      puts "EXECUTED!"
      ::ActionView::Base.class_eval do
        include HandyForm::Helpers
      end
    end
  end
end
