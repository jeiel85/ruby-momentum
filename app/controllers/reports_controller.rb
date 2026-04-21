class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = current_user.reports.build(report_params)

    if @report.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back(fallback_location: root_path, notice: "Report submitted. Thank you!") }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error", partial: "shared/error", locals: { message: @report.errors.full_messages.join(", ") }) }
        format.html { redirect_back(fallback_location: root_path, alert: @report.errors.full_messages.join(", ")) }
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:post_id, :comment_id, :reason, :description)
  end
end

