module ApplicationHelper
  def render_svg(name, styles: "fill-current text-gray-500", title:nil)
    filename = "#{name}.svg"
    title ||= name.underscore.humanize
    inline_svg_tag(filename, aria: true, nocomment: true, title: title, class: styles)
  end

  def language_color(language) 
    case language.downcase
      when language = 'ruby' 
        'pink'
      when language = 'javascript'
        'yellow'
      when language = 'python'
        'blue'
    end
  end

end
