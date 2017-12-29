class Textile2Markdown
  def convert(textile)
    md = ''

    textile.each_line do |textile_line|
      md += convert_line(textile_line)
    end

    md
  end
  
  def convert_line(input)
    tmp = convert_links(input)
    tmp = convert_ul(tmp)
    tmp = convert_ol(tmp)
    tmp = convert_headings(tmp)
    tmp = escape_emphasis(tmp)
    tmp = escape_unescaped_underscores(tmp)
    tmp
  end
  
  protected

  def convert_links(input)
    input.gsub(/"(.*?)":(.+?)(?=,| |$)/, '[\1](\2)') 
  end

  def convert_ul(input)
    input.gsub(/^\*\*\*\* /, '      * ').gsub(/^\*\*\* /, '    * ').gsub(/^\*\* /, '  * ')
  end

  def convert_ol(input)
    input.gsub(/^####/, '         1.').gsub(/^###/, '      1.').gsub(/^##/, '   1.').gsub(/^#/, '1.')
  end

  def convert_headings(input)
    input.gsub(/^h(\d)\./) {|match| '#' * $1.to_i }
  end

  def escape_unescaped_underscores(input)
    # two passes required to handle double-underscores, not sure why 
    regexp = /([^\\])_/
    input.gsub(regexp, '\1\_').gsub(regexp, '\1\_')
  end

  def escape_emphasis(input)
    tmp = input
    tmp.gsub!(/(^| )(\*)([^_* ].+?[^_*])(\*)($| )/, '\1**\3**\5')
    tmp.gsub!(/(^| )(__|_)([^_* ].+?[^_*])(__|_)($| )/, '\1*\3*\5')
    tmp.gsub!(/(^| )(\*_|\*\*__)([^_* ].+?[^_*])(_\*|__\*\*)($| )/, '\1***\3***\5')
    tmp
  end

end
