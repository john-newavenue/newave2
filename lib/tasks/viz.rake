namespace :viz do
  desc "Generate ERD diagram"
  task :erd => :environment do
    path = "tmp/erd.pdf"
    system("erd --filename=#{path}")
    puts "See #{path}"
  end
end