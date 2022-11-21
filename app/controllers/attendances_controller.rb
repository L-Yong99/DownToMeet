class AttendancesController < ApplicationController
  def index
    @attendances = Attendance.where(status: 'accepted', user: current_user)
    @attendances_upcoming = @attendances.joins(:event).where("events.date >= ?", Date.today)
    @attendances_upcoming_dates = @attendances_upcoming.joins(:event).distinct.order("events.date").pluck("events.date")
    set_dates = @attendances_upcoming_dates.map do |d|
      d
    end
    @set_dates = set_dates.to_json
    if params[:date].present?
      @attendances = Attendance.where(status: 'accepted', user: current_user)
      @attendances_upcoming = @attendances.joins(:event).where("events.date = ?", params[:date])
      @attendances_upcoming_dates = @attendances_upcoming.joins(:event).distinct.order("events.date").pluck("events.date")
      # @attendances = Attendance.joins(:event).where(["events.date = ? and attendances.user_id = ? and attendances.status = ?", params[:date],current_user.id,"accepted"])
      @date_set = params[:date];
      @attendance_count = @attendances_upcoming_dates.count
    else
      # @attendances = Attendance.where(status: 'accepted', user: current_user)
      # @attendances_upcoming = @attendances.joins(:event).where("events.date >= ?", Date.today)
      @attendances_upcoming_dates = @attendances_upcoming.joins(:event).distinct.order("events.date").pluck("events.date")
      @attendance_count = @attendances_upcoming_dates.count
      # raise
    end
  end

  def create
    # @user = User.find(params[:user_id])
    event = Event.find(params[:event_id])
    attendance = Attendance.new(user:current_user, event:event)
    if event.private
      attendance.status = 'pending'
      attendance.save
      redirect_to event_path(event)
    else
      attendance.status = 'accepted'
      attendance.save
      redirect_to user_attendances_path(current_user)
    end
  end

  def show

  end

  def destroy
    attendance = Attendance.find(params[:id])
    go_current = attendance.user == current_user
    event = attendance .event
    attendance.destroy
    if go_current
      redirect_to user_attendances_path(current_user)
    else
      redirect_to event_path(event)
    end
  end
end
