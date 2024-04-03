module ApplicationHelper

  def turbo_stream_flash
    turbo_stream.update "flash_message", partial: "shared/flash_message"
  end

  def page_title(page_title = "")
    base_title = "INDOOR BABY GUARDIAN"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def default_meta_tags
    {
      site: 'アプリ名',
      title: 'グッズを活用した室内における子どもの安全対策',
      reverse: true,
      charset: 'utf-8',
      description: '診断結果に応じて、グッズを活用した室内における子どもの安全対策を紹介しています。',
      keywords: '子ども,室内,安全対策,リスク管理,グッズ,診断',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon_test3.ico') }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('test_twitter.jpg'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@OhmuraTomo',
        image: image_url('test_twitter.jpg')
      }
    }
  end
  
end
