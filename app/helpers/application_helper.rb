module ApplicationHelper
  def title(text)
    page_tilte = ''
    page_tilte = "#{text} - " unless text.blank?
    page_tilte << 'Sunline'
  end
end
