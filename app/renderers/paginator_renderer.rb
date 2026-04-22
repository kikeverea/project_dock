class PaginatorRenderer < WillPaginate::ActionView::LinkRenderer
  def link(text, target, attributes = {})
    extra = @options[:link_options] || {}

    # merge in extra HTML options (data:, aria:, class:, etc.)
    attributes = attributes.merge(extra) do |_k, old_v, new_v|
      old_v.is_a?(Hash) && new_v.is_a?(Hash) ? old_v.merge(new_v) : new_v
    end

    super(text, target, attributes)
  end
end
