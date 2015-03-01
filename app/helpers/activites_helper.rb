module ActivitesHelper

  def activity_creator( activity )
    # some text to describe the "owner"; may only be for message
    case activity.activity_type
    when 'message'
      activity.creator.name
    else
      ''
    end
  end
end
