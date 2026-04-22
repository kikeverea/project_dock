module ApplicationHelper

  def comment
  end

  def opportunities_count(count, other_count = 0)
    badge = render(
      "components/outline_badge",
      text: count,
      color: "#FAD839",
      use_style_for_color: true,
      classes: "d-inline-block opacity-50 fw-bold ms-4 me-1") if count + other_count > 0

    other_badge = render(
      "components/outline_badge",
      text: other_count,
      color: "#FAD839",
      use_style_for_color: true,
      classes: "d-inline-block opacity-50 fw-bold ms-1"
    ) if other_count > 0

    other_badge ? "#{badge} + #{other_badge}".html_safe : badge
  end

  # noinspection RubyNestedTernaryOperatorsInspection
  def time_ago(date)
    return "-" if date.nil?

    labels = {
      year: { singular: "año", plural: "años" },
      month: { singular: "mes", plural: "meses" },
      day: { singular: "día", plural: "días" },
    }

    days_ago = (Date.current - date.to_date).to_i
    months_ago = days_ago / 30 if days_ago > 30
    years_ago = days_ago / 365 if days_ago > 365

    units_ago = years_ago || months_ago || days_ago
    form = units_ago > 1 ? :plural : :singular
    unit = years_ago ? :year : months_ago ? :month : :day

    return "Hoy" if days_ago == 0
    return "Ayer" if days_ago == 1
    "Hace #{units_ago} #{labels[unit][form]}"
  end

  def time_count(date)
    return "-" if date.nil?

    labels = {
      year: { singular: "año", plural: "años" },
      month: { singular: "mes", plural: "meses" },
      day: { singular: "día", plural: "días" },
    }

    days_ago = (Date.current - date.to_date).to_i
    months_ago = days_ago / 30 if days_ago > 30
    years_ago = days_ago / 365 if days_ago > 365

    units_ago = years_ago || months_ago || days_ago
    form = units_ago == 1 ? :plural : :singular
    unit = years_ago ? :year : months_ago ? :month : :day

    "#{units_ago} #{labels[unit][form]}"
  end

  def to_currency(value)
    show_decimals = value.to_i != value

    "#{number_to_currency(value, unit: '', separator: ',', delimiter: '.', precision: show_decimals ? 2 : 0)} €"
  end

  def external_link(path)
    return "-" if path.blank?

    path.start_with?('http') ?
      path :
      "https://#{path}"
  end

  def records_per_page(page, per_page, total)
    page = page.to_i - 1
    per_page = per_page.to_i

    start = [page * per_page, 1].min
    last = [start + per_page, total].min

    total > 0 ?
      "Mostrando #{start + 1} - #{last} de #{total} entradas" :
      "No hay entradas"
  end

  def text_color_for_background(background)
    return 'black' unless background

    hex_color = background.delete('#')
    hex_color = hex_color.chars.map { |c| c * 2 }.join if hex_color.length == 3

    r, g, b = hex_color.scan(/../).map(&:hex)

    brightness = (r * 299 + g * 587 + b * 114) / 1000.0
    brightness > 128 ? 'black' : 'white'
  end

  def parse_expiration_date(date)
    return "<em class='text-muted'>Sin fecha</em>".html_safe unless date.present?

    date.to_date == Time.current.to_date ?
      "Hoy" :
      date.strftime("%d-%m-%Y")
  end

  def day_counter_color(days, danger: 0, warning: 5, success_color: "success")
    if danger && days < danger
      "danger"
    elsif warning && days <= warning
      "warning"
    else
      success_color
    end
  end

  def boolean_icon(boolean)
    boolean ?
      "<i class='fa-solid fa-check text-success'></i>".html_safe :
      "<i class='fa-solid fa-xmark text-danger'></i>".html_safe
  end

  def log_action_color(action)
    case action.to_s.downcase
    when "created", "uploaded"
      "primary"
    when "updated"
      "success"
    when "deleted", "upload_deleted"
      "danger"
    when "completed"
      "info"
    else
      "gray-600"
    end
  end

end
