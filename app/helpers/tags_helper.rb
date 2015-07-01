require 'pygments'
require 'redcarpet'
require 'yaml'

module TagsHelper
    def markdown(text)
        options = {
            filter_html: true
        }
        extensions = {
            autolink:           true,
            superscript:        true,
            fenced_code_blocks: true
        }
        renderer = Redcarpet::Render::HTML.new(options)
        markdown = Redcarpet::Markdown.new(renderer, extensions)
        markdown.render(text).html_safe
    end

    def highlight(code, language)
        options = {encoding: 'utf-8'}
        Pygments.highlight(code, lexer: get_lexer(language), options: options).html_safe
    end

    def svg(filename, options = {})
        assets = Rails.application.assets
        file = assets.find_asset(filename)
        return "" if file.nil?
        doc = Nokogiri::HTML::DocumentFragment.parse file.source.force_encoding("UTF-8")
        svg = doc.at_css "svg"
        if options[:class].present?
            svg["class"] = options[:class]
        end
        raw doc
    end

    private
    def get_lexer(language)
        file = File.join(Rails.root, 'lib', 'ace_to_pygments_map.yml')
        map = YAML.load_file(file)
        if map[language]
            return map[language]['lexer']
        end
        return 'text'
    end
end
