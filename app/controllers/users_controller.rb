class UsersController < ApplicationController
  def show
    @usr = load_user
  end

  def reviews
    @usr     = load_user
    @reviews = @usr.reviews.page params[:page]
  end

  def comments
    @usr      = load_user
    @comments = @usr.comments.page params[:page]
  end

  def flags
    @usr     = load_user
    viewable = @user.id == @usr.id || @user.admin?
    render html: 'Sorry, you do not have permission to view this page.', layout: true unless viewable
  end

  private

  def load_user
    attrs = %i(id display_name email is_admin is_moderator)
    Person.select(attrs).find helpers.obs(params[:id])
  end
end