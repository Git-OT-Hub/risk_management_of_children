module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update "flash_message", partial: "shared/flash_message"
  end

  def page_title(page_title = "")
    base_title = "INDOOR BABY GUARDIAN"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def images_as_medium(image)
    image.variant(resize_to_limit: [500, 500]).processed.url
  end
end
