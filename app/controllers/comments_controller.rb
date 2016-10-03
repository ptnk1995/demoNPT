class CommentsController < ApplicationController
 before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
 before_action :find_post
 before_action :find_comment, only:[:show, :destroy, :edit, :update, :comment_ower]
 before_action :comment_ower, only:[:show, :destroy, :edit, :update]

 def create
  @comment = @micropost.comments.create(params[:comment].permit(:content))
  @comments = Comment.where(micropost_id: @micropost).order('created_at DESC')
  @comment.user_id= current_user.id
  @comment.save
  flash[:success] = "Comment sucess!"
  if @comment.save
    redirect_to micropost_path(@micropost)
  else
    render 'microposts/show'
  end
end

def destroy
  @comment.destroy

  redirect_to micropost_path(@micropost)
end

def edit
  @comment = Comment.find(params[:id])
end


def show

end
def update
  if @comment.update(params[:comment].permit(:content))
    redirect_to micropost_path(@micropost)
  else
    render 'edit'
  end
end

private
def find_post
  @micropost = Micropost.find(params[:micropost_id])
end

def find_comment
  @comment = @micropost.comments.find(params[:id])
end

def comment_ower
  unless current_user.id = @comment.user_id
    flash[:notice] = "you shall not pass"
    redirect_to @micropost

  end
end
end
