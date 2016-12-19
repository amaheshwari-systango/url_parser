module Api::V1
class PagesController < ApiController

  # GET /v1/pages
  def index
    render json: Page.all
  end

  # POST /v1/users
  def create
    render json: {success: "false", error: "Please enter URL."} and return unless params[:page][:url]
    page = Page.find_or_initialize_by(permitted_page_params)
    render json: {success: "false", error: "Please enter valid URL."} and return unless page.valid?
    unless page.persisted?
      html_page = MetaInspector.new(params[:page][:url])
      links_array = html_page.links.all
      h1_array, h2_array, h3_array = fetch_head_tags_value(html_page)
      page.content = {"h1": h1_array, "h2": h2_array, "h3": h3_array, "links": links_array}
      page.save
    end
    render json: page
  end

    private
      def permitted_page_params
        params.require(:page).permit(:url)
      end

      def fetch_head_tags_value(html_page)
        result = Nokogiri::HTML(html_page.to_s)
        [result.css('h1').map{|ele| ele.text.strip},
         result.css('h2').map{|ele| ele.text.strip},
         result.css('h3').map{|ele| ele.text.strip}]
      end
  end
end