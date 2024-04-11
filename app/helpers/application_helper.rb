module ApplicationHelper

  def turbo_stream_flash
    turbo_stream.update "flash_message", partial: "shared/flash_message"
  end

  def page_title(page_title = "")
    base_title = "Little Ones Safety"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def default_meta_tags
    {
      site: 'Little Ones Safety',
      title: '自宅内での子どもの安全を考えよう',
      reverse: true,
      charset: 'utf-8',
      description: '診断結果に応じて、グッズを活用した自宅内における子どものための安全対策を紹介しています。',
      keywords: '子ども,室内,安全対策,リスク管理,グッズ,診断',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon_riskApp.ico') }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('X_card_s_large.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary',
        site: '@OhmuraTomo',
        image: image_url('X_card_s_small.png')
      }
    }
  end
  
end
