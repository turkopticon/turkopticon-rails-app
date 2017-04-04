module MiniMarkdown
  class << self
    def render(input)
      renderer.render(input)
    end

    private

    def renderer
      @renderer ||= Redcarpet::Markdown.new rndr, md_config
    end

    def rndr
      opts = {
          safe_links_only: true,
          filter_html:     true,
          no_images:       true,
          no_styles:       true,
          hard_wrap:       true,
          link_attributes: { rel: 'nofollow' }
      }
      MiniRender.new opts
    end

    def md_config
      {
          space_after_headers:          true,
          fenced_code_blocks:           true,
          autolink:                     true,
          superscript:                  true,
          underline:                    true,
          no_intra_emphasis:            true,
          tables:                       false,
          strikethrough:                true,
          disable_indented_code_blocks: true
      }
    end
  end

  class MiniRender < Redcarpet::Render::HTML
    def header(txt, level)
      '#' * level + txt
    end
  end
end


