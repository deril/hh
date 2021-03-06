namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    Rake::Task["db:reset"].invoke
    Rake::Task["db:migrate"].invoke

    puts "Creating groups..."
    groups = []
    %w(Group_1 Group_2 Group_3).each do |cat|
      groups << Group.find_or_create_by!(name: cat)
    end

    puts "Creating tags..."
    tags = []
    %w(Tag_1 Tag_10 Tag_100 Tag_1000).each do |tag|
      tags << groups[0].tags.find_or_create_by!(name: tag)
    end
    %w(Tag_2 Tag_20).each do |tag|
      tags << groups[1].tags.find_or_create_by!(name: tag)
    end
    %w(Tag_3 Tag_30 Tag_300 Tag_3000 Tag_30000).each do |tag|
      tags << groups[2].tags.find_or_create_by!(name: tag)
    end

    %w(Tag_4 Tag_40 Tag_400 Tag_4000 Tag_40000).each do |tag|
      tags << groups[0].tags.find_or_create_by!(name: tag)
    end

    %w(Tag_5 Tag_50 Tag_500 Tag_5000 Tag_50000).each do |tag|
      tags << groups[1].tags.find_or_create_by!(name: tag)
    end

    %w(Tag_6 Tag_60 Tag_600 Tag_6000 Tag_60000).each do |tag|
      tags << groups[2].tags.find_or_create_by!(name: tag)
    end

    puts "Creating images..."
    tags_size_set = (1...tags.size)
    100.times do |n|
      image = File.open(Dir.glob(File.join(Rails.root, 'lib/assets/images', '*')).sample)
      img = Image.create!(image: image, warn_id: rand(1..4))
      img.tags.push(tags.sample(20))
    end
    Rake::Task["db:seed"].invoke
    Rake::Task["db:test:prepare"].invoke
  end
end

