class LessionLogsController < ApplicationController
  before_action :find_lession_log, only: %i(show update)

  def index
    redirect_to root_path if current_user? current_user
  end

  def create
    @lession_log = LessionLog.create user_id: current_user[:id],
      lession_id: params[:id]
    lession_log.create_lession_log
    redirect_to lession_log
  end

  def show
    redirect_to root_path unless current_user
    @question_logs = lession_log.question_logs
    @questions, @answers = LessionLog.get_lession_log @question_logs
    return if lession_log.pass.nil?
    @corrects = Answer.get_correct_answers @answers
  end

  def update
    @question_logs = if params[:questionlog]
                       params[:questionlog]
                     else
                       Settings.number.zero
                     end
    lession_log.update_result @question_logs, params[:commit]
    redirect_to profile_path
  end

  private

  attr_reader :lession_log

  def find_lession_log
    @lession_log = LessionLog.find_by id: params[:id]
    return if lession_log
    flash[:danger] = t ".danger"
    redirect_to root_path
  end
end
