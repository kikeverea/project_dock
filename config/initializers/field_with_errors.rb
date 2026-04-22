Rails.application.config.action_view.field_error_proc = Proc.new do |html_tag, _instance|
  # Uncomment this to confirm it's running
  # Rails.logger.info "🔥 field_error_proc HIT for #{html_tag}"

  if html_tag =~ /<(input|textarea|select)/
    doc = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    doc.children.each do |node|
      existing_classes = node['class'] || ''
      node['class'] = (existing_classes.split + ['is-invalid']).uniq.join(' ')
    end
    doc.to_html.html_safe
  else
    html_tag.html_safe
  end
end
