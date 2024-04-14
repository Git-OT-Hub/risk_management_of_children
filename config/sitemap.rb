# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.indoor-baby-guardian.com"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-ap-northeast-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['S3_BUCKET_NAME'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  aws_region: 'ap-northeast-1',
)

SitemapGenerator::Sitemap.create do
  add root_path, :priority => 0.5, :changefreq => 'monthly'

  add posts_path, :priority => 0.7, :changefreq => 'daily'

  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end

  add diagnosis_questions_path, :priority => 0.5, :changefreq => 'monthly'
end
