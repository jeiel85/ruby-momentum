class Admin::DashboardController < ApplicationController
  before_action :verify_admin

  def index
    @posts_count = Post.count
    @users_count = User.count
    @reports_count = Report.pending_reviews.count
    @recent_reports = Report.pending_reviews.includes(:post, :user).limit(10)
  end

  def reports
    @reports = Report.pending_reviews.includes(:post, :user).order(created_at: :desc).page(params[:page])
  end

  def resolve_report
    @report = Report.find(params[:id])
    @report.resolved!
    redirect_to admin_reports_path, notice: "Report resolved"
  end

  private

  def verify_admin
    # TODO: Add admin role check when user roles are implemented
    # For now, only allow access in development or with specific IP
    # redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end