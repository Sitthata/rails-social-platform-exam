module ActivitiesHelper
  def activity_partial(activity)
    case [ activity.trackable_type, activity.action ]
    when [ "Post", "create" ]
      activity.trackable ? "activities/posts/create" : "activities/missing_target"
    when [ "Post", "delete" ]
      "activities/posts/delete"
    when [ "Comment", "create" ]
      activity.trackable ? "activities/comments/create" : "activities/missing_target"
    else
      "activities/unknown"
    end
  end
end
