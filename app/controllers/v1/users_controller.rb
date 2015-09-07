class V1::UsersController < V1::BaseController
  skip_before_filter :verify_authenticity_token
  require 'rmagick'
  include Magick

  def create
    user_name = _user_params[:name]
    if _user_params[:avatar].to_s.empty?
      _user_params[:avatar] = draw_image(user_name)
    end
    # user = User.create!(_user_params)
    render json: {status: "ok"}, root: false
  end

  def index
    user_name = "Mai Thi Hong My"
    draw_image(user_name)
  end

  def draw_image(user_name)
    img = Magick::Image.new(96, 96){self.background_color = 'white'}
    name = user_name.split(" ")
    name = name[0][0] + name[-1][0]
    txt = Draw.new
    # img.annotate(img, width, height, x, y, text)
    img.annotate(txt, 0, 0, 0, 35, name){
      txt.gravity = Magick::SouthGravity
      txt.pointsize = 26
      txt.fill = '#3D3D3D'
      txt.font_weight = Magick::BoldWeight
    }
    img.format = 'jpeg'
    send_data img.to_blob, :stream => 'false', :filename => 'avatar-default.jpg', :type => 'image/jpeg', :disposition => 'inline'
  end

  private

  def _user_params
    params.permit(:name, :avatar)
  end
end
