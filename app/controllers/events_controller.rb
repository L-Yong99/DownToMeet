class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @pending_attendances = Attendance.where(event: @event , status: 'pending')
    @accepted_attendances = Attendance.where(event: @event , status: 'accepted')
    @user_attending = Attendance.find_by(event: @event , user:current_user, status: 'accepted')
    @spot_left =  @event.spots - @accepted_attendances.count
  end

  def new

  end

  def create
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to events_user_path(current_user)
  end

  def hosted_event
    @hosted_events = Event.where(user:current_user)
    @count = @hosted_events.map do |hosted_event|
      pending_count = Attendance.where(event: hosted_event, status: 'pending').count
      accepted_count = Attendance.where(event: hosted_event, status: 'accepted').count
      { pending_count: pending_count,
      accepted_count: accepted_count
      }
    end
  end

  def hosted_event_detail
  @hosted_event = Event.find(params[:id])
    if current_user == @hosted_event.user
      @pending_attendances = Attendance.where(event: @hosted_event, status: 'pending')
   else
      redirect_to events_user_path(current_user)
   end
  end

  def hosted_event_patch
    @hosted_event = Event.find(params[:id])
    @user = User.find(params[:user_id])
    attendance = Attendance.find_by(event: @hosted_event, user: @user)
    attendance.status = 'accepted'
    attendance.save
    redirect_to event_path(@hosted_event)
  end
end
