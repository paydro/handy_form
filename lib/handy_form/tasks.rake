namespace :handy_form do
  desc "Copy handy_form css files into your rails application"
  task :css_install do
    gemdir = File.join(File.dirname(__FILE__), "..", "..",)
    print "\nCopying 'forms.css' to rails' public/stylesheets dir ... "
    FileUtils.cp(
      File.join(gemdir, "css", "forms.css"),
      Rails.root.join("public", "stylesheets")
    )
    puts "Done."
  end
end
