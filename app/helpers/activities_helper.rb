module ActivitiesHelper
  def activity_partial(activity)
    case [ activity.trackable_type, activity.action ]
    when [ "Post", "create" ]
      "activities/posts/create"
    when [ "Comment", "create" ]
      "activities/comments/create"
    else
      "activities/unknown"
    end
  end
end
