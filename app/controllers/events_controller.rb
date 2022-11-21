class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    if user_signed_in?
      pc = Attendance.joins(:event).where("events.date >= ?", Date.today).where("events.user_id = ?", current_user.id).where(status:"pending").count
      if pc > 0
        flash[:info] = "You have #{pc} pending requests"
      end
    end
    @events = Event.all
    events_upcoming = Event.where("date >= ?", Date.today)
    all_dates = Event.distinct(:date).select(:date).order(:date)
    @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
    @set_dates =[].to_json
    # Find all hosted events by users

    # where(events.user: current_user, status: "pending")
    myhosted = Event.where("date >= ?", Date.today).where(user: current_user)
    @all_dates_upcoming_count = 999
    if params[:date].present?
      @events_upcoming = Event.where("date = ?", params[:date])
      all_dates = @events_upcoming.distinct(:date).select(:date).order(:date)
      @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
      @all_dates_upcoming_count = @all_dates_upcoming.count
      if @all_dates_upcoming_count.nil?
        @all_dates_upcoming_count = 0
      end
      @date_set = params[:date];
    else
      @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
    end
    @attendances = Attendance.all
  end

  def show
    @event = Event.find(params[:id])
    @pending_attendances = Attendance.where(event: @event , status: 'pending')
    @accepted_attendances = Attendance.where(event: @event , status: 'accepted')
    @user_attending = Attendance.find_by(event: @event , user:current_user, status: 'accepted')
    @spot_left =  @event.spots - @accepted_attendances.count
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.save
    redirect_to event_path(@event)
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to events_user_path(current_user)
  end

  def search
    @events = Event.all
    @attendances = Attendance.all
    if params[:query].present?
      sql_query = "name ILIKE :query OR user ILIKE :query"
      @events = Event.where(sql_query, query: "%#{params[:query]}%")
      @events_upcoming = @events.where("date >= ?", Date.today)
      # @all_dates_upcoming = @events_upcoming.distinct(:date).select(:date).order(:date)
      @all_dates_upcoming = @events_upcoming.distinct(:date).order(:date).pluck("date")
      # @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
      # raise
    end

    @markers = @events_upcoming.geocoded.map do |event|
      {
        event: event.to_json,
        lat: event.latitude,
        lng: event.longitude,
        info_window: render_to_string(partial: "info_window", locals: {event: event}),
        image_url: helpers.asset_url("bluemarker.png")
      }
    end

    # events_upcoming = Event.where("date >= ?", Date.today)
    # all_dates = Event.distinct(:date).select(:date).order(:date)
    # @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
    # # set_dates = @all_dates_upcoming.map do |d|
    # #   d.date
    # # end
    # # @set_dates = set_dates.to_json
    # @set_dates =[].to_json
    # if params[:date].present?
    #   @events_upcoming = Event.where("date = ?", params[:date])
    #   all_dates = @events_upcoming.distinct(:date).select(:date).order(:date)
    #   @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
    #   @date_set = params[:date];
    # else
    #   @all_dates_upcoming = all_dates.where("date >= ?", Date.today)
    # end
    # @attendances = Attendance.all
  end

  def hosted_event
    @hosted_events_upcoming_dates_0 = Event.where("events.date >= ?", Date.today)
    @hosted_events_upcoming_dates = @hosted_events_upcoming_dates_0.where(user:current_user).distinct.order("date").pluck("date")
    @hosted_events_upcoming_dates_count = @hosted_events_upcoming_dates.count
    # @hosted_events_upcoming_dates = Event.where("events.date >= ?", Date.today).distinct.order("date").pluck("date")
    set_dates = @hosted_events_upcoming_dates.map do |d|
      d
    end
    @set_dates = set_dates.to_json
    @date_set = params[:date];
    if params[:date].present?
      @hosted_events_upcoming_dates_0 = Event.where("events.date = ?", params[:date])
      @hosted_events_upcoming_dates = @hosted_events_upcoming_dates_0.where(user:current_user).distinct.order("date").pluck("date")
      @hosted_events_upcoming_dates_count = @hosted_events_upcoming_dates.count
      # @hosted_events_upcoming_dates = Event.where("events.date = ?", params[:date]).distinct.order("date").pluck("date")
      # @attendances = Attendance.where(status: 'accepted', user: current_user)
      # @attendances_upcoming = @attendances.joins(:event).where("events.date = ?", params[:date])
      # @attendances_upcoming_dates = @attendances_upcoming.joins(:event).distinct.pluck("events.date")
      # # @attendances = Attendance.joins(:event).where(["events.date = ? and attendances.user_id = ? and attendances.status = ?", params[:date],current_user.id,"accepted"])
      # @date_set = params[:date];
    end
    # @hosted_events = Event.where(user:current_user)
    # @count = @hosted_events.map do |hosted_event|
    #   pending_count = Attendance.where(event: hosted_event, status: 'pending').count
    #   accepted_count = Attendance.where(event: hosted_event, status: 'accepted').count
    #   { pending_count: pending_count,
    #   accepted_count: accepted_count
    #   }
    # end
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

private

def event_params
  params.require(:event).permit(:name, :photo, :detail, :category, :date, :time, :address, :spots, :private)
end
