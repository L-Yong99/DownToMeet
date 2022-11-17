class AttendancesController < ApplicationController
  def index
    @attendances = Attendance.where(status: 'accepted', user: current_user)
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
