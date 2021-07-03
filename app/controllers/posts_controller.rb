class PostsController < ApplicationController
  def create
    authorize Post, :manage?
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.valid?
      @post.save
      @post.notify!
    end

    redirect_to dashboard_index_path
  end

  def destroy
    authorize Post, :manage?

    post = Post.find(params[:id])
    post.destroy

    redirect_to dashboard_index_path
  end

  def pin
    authorize Post, :manage?
    post = Post.find(params[:id])
    post.update pinned: true

    redirect_to dashboard_index_path
  end

  def unpin
    authorize Post, :manage?
    post = Post.find(params[:id])
    post.update pinned: false

    redirect_to dashboard_index_path
  end

  private
    def post_params
      params[:post].permit(:text)
    end
end
