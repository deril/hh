# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://hentaria.com"

SitemapGenerator::Sitemap.create do
  add images_path, priority: 0.7, changefreq: 'daily'
  Image.find_each do |image|
    add image_path(image)
  end
  add tags_path, priority: 0.7, changefreq: 'daily'
  Tag.find_each do |tag|
    add tag_path(tag)
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
