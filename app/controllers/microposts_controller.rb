class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t ".success_mess_created"
      redirect_to root_path
    else
      @feed_items = current_user.feed.page(params[:page]).per Settings.collections.microposts_default_page
      flash.now[:danger] = t ".fail_mess_created"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".success_mess_deleted"
    else
      flash[:warning] = t ".fail_mess_deleted"
    end
    redirect_to fallback_location: root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def load_micropost
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:warning] = t "microposts.not_found"
    redirect_to root_path
  end
end
