namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    
    Rake::Task["db:reset"].invoke
    Rake::Task["db:migrate"].invoke

    puts "Creating groups..."
    %w(Activity Creature Attribute).each do |cat|
      Group.create!(name: cat)
    end
    
    puts "Creating tags..."
    %w(Bestiality Cheating Netorare Swinging).each do |tag|
      Group.find(2).tags.create(name: tag)
    end
    %w(Furry Monster).each do |tag|
      Group.find(3).tags.create!(name: tag)
    end
    %w(Futanari Shemale Big\ Breasts Huge\ Breasts).each do |tag|
      Group.find(4).tags.create!(name: tag)
    end
    
    puts "Creating images..."
    100.times do |n|
      image = File.open(Dir.glob(File.join(Rails.root, 'sampleimages', '*')).sample)
      img = Image.create!(image: image)
      img.tags.push(Tag.find(rand(1..10)), Tag.find(rand(1..10)), Tag.find(rand(1..10)))
    end   
  end
end

