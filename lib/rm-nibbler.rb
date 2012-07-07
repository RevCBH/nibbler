require "nibbler/version"

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  files = [
    %w{version},
    :core,
    %w{alert controller},
    {views: %w{view button nav_bar picker text_field toolbar}}
  ]

  dir = File.dirname(__FILE__)

  files = files.map do |xs|
    puts "xs: #{xs}"
    name = "nibbler"
    if xs.kind_of? Hash
      name = File.join(name, xs.keys[0].to_s)
      xs.values[0].map {|x| File.join(dir, name, "#{x}.rb")}
    elsif xs.kind_of? Symbol
      name = File.join(name, xs.to_s)
      puts "\t| #{File.join(dir, name, '*.rb')}"
      res = Dir.glob(File.join(dir, name, '*.rb'))
      puts "\t| -> #{res.count}"
      res.each {|r| puts "\t|\t|#{r}"}
      res
    else
      xs.map {|x| File.join(dir, name, "#{x}.rb")}
    end
  end

  app.files.unshift files.flatten

  #files = Dir.glob(File.join(File.dirname(__FILE__), 'nibbler/**/*.rb'))#.map do |file|
    #app.files.unshift(file) file
  #end
  #files.unshift(File.join(File.dirname(__FILE__), 'nibbler/controller.rb')
end
