module ApplicationHelper
  def comment
  end

  def breadcrumbs(*crumbs)
    render("components/breadcrumbs", crumbs: crumbs)
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

  def boolean_icon(boolean)
    boolean ?
      "<i class='fa-solid fa-check text-success'></i>".html_safe :
      "<i class='fa-solid fa-xmark text-danger'></i>".html_safe
  end
end
