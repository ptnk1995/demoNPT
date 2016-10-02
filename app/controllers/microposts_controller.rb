class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @posts = Micropost.paginate page: params[:page], per_page: 3
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = Comment.where(micropost_id: @micropost).order('created_at DESC')
  end


def create
  @micropost = current_user.microposts.build(micropost_params)
  if @micropost.save
    flash[:success] = "Entry created!"
    redirect_to root_url
  else
    @feed_items = []
    render 'static_pages/home'
  end
end

def edit
  @micropost = Micropost.find(params[:id])
end

def update
  @micropost = Micropost.find(params[:id])
  if @micropost.update_attributes(micropost_params)
    flash[:success] = "Entry updated"
    redirect_to ''
  else
    render ''
  end
end

def destroy
  @micropost.destroy
  flash[:success] = "Entry deleted"
  redirect_to 'home/home' || root_url
end

private
def micropost_params
  params.require(:micropost).permit(:content, :title, :picture)
end

def correct_user
  @micropost = current_user.microposts.find_by(id: params[:id])
  redirect_to root_url if @micropost.nil?
end
end
