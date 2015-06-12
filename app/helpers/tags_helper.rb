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
