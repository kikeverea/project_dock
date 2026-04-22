if Rails.env.test?

  # Override the asset helpers to do nothing in test environment
  ActionView::Helpers::AssetTagHelper.module_eval do
    def image_tag(source, _options = {})
      # Return a placeholder string, so tests don't fail looking for actual images
      "<img src='#{source}' } />".html_safe
    end

    def javascript_include_tag(*sources)
      # Skip JS includes in test environment
      sources.map { |source| "<script src='#{source}.js'></script>" }.join("\n").html_safe
    end

    def stylesheet_link_tag(*sources)
      # Skip CSS includes in test environment
      sources.map { |source| "<link href='#{source}.css' rel='stylesheet' />" }.join("\n").html_safe
    end

    def asset_path(_args)
      "/public"
    end
  end
end
