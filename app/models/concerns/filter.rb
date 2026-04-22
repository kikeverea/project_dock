class Filter

  def self.get_filter(items, filter_params)
    return {} unless items

    items.each_with_object({}) do |item, filter|
      filter_params.each do |filter_param|

        filter_name, param, args = filter_param
        args ||= {}
        values = [*param.call(item), args[:label]&.call(item)]

        # If value present, merge with values array
        filter[filter_name] ||= { values: [], **args }
        filter[filter_name][:values] = (filter[filter_name][:values] | [values]) unless values.empty?
      end
    end
  end

  private

  def self.get_option_name(option_name)
    option_name.is_a?(Array) ? option_name.first : option_name
  end

  def self.get_option(item, option_name)
    return if !item

    if option_name.is_a? Array
      option_name.length == 1 ?
        item.send(option_name.first) :
        get_option(item.send(option_name.first), option_name.slice(1...))
    else
      item.send(option_name)
    end
  end
end
