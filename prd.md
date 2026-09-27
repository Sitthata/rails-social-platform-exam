# Social Platform Exam Practice

## Purpose

Build a small Rails social app while learning to explain its code. Practice polymorphic associations, migrations and indexes, dynamic partial rendering, model callbacks, and one model test. Implement activity tracking ourselves without the public_activity gem.

## Agreed approach

- Rails 8.1 with SQLite, server-rendered ERB views, and Minitest.
- Devise authentication using email and password. Display email as the user's identity.
- Four models: User, Post, Comment, and Activity.
- Generate Post and Comment scaffolds, then adapt the generated controllers and views.
- Generate Activity as a model with an index-only controller for the feed.
- Create activities through after_create callbacks on Post and Comment. No service objects for this version.
- Work incrementally: discuss each step, let the learner run generator commands, then explain and adapt the generated code together.

## User stories and acceptance criteria

### 1. Sign in and out

As a user, I want to sign in with my email and password so that actions are attributed to my account.

- Valid credentials lead to the posts list.
- Invalid credentials display an error.
- Users can sign out.
- All post, comment, and activity pages and actions require authentication.
- Provide at least two development accounts through seeds to practice interactions and ownership checks.
- Public registration, password reset, account editing, and account deletion are outside this version's scope. Configure Devise accordingly.

### 2. Manage my posts

As a user, I want to create, read, edit, and delete my own posts so that I can share content.

- A post requires a nonblank title and body.
- The server assigns the signed-in user as the author; submitted user IDs cannot override ownership.
- Only the author can update or delete the post, enforced in the controller as well as the UI.
- Creating a post creates exactly one Activity with action `create`, the author as user, and the post as trackable.
- Updating a post does not create another Activity.
- Invalid posts create neither a Post nor an Activity.

### 3. Read everyone's posts

As a user, I want to browse my posts and other users' posts so that I can read what people share.

- List all existing posts, newest first.
- Show each post's title, author email, and creation time.
- A post detail page displays its body, comments, comment form, and activity history.

### 4. Comment on a post

As a user, I want to comment on a post so that I can join the discussion.

- Users can comment on their own posts and other users' posts.
- A comment requires a nonblank body and belongs to an existing post and its author.
- The server assigns the signed-in user as author and uses the post being commented on as the parent.
- Creating a comment creates exactly one Activity with action `create`, the commenter as user, and the comment as trackable.
- Invalid comments create neither a Comment nor an Activity.
- Display comments oldest first with author email, body, and creation time.
- Comment editing and individual deletion are outside scope; remove those generated routes and controls.

### 5. Read activity history

As a user, I want to see who created a post and who commented on it so that I can follow the discussion.

- On a post detail page, show activities whose trackable is that post or one of its comments.
- Provide a separate global activity feed containing all users' activities, newest first.
- Each activity shows the actor's email, time, and an event description.
- Choose partials based on the trackable type and supported action.
- Post creation displays a message such as `first@example.com created a post: A good day`.
- Comment creation displays a message such as `jane@example.com commented: Hope you have fun`.
- Activity has no user-facing create, edit, or delete form.

### 6. Preserve history after deleting a post

As a user, I want deleted content to disappear while its activity history remains understandable.

- Deleting a post also deletes its comments.
- Preserve the Activity rows for both the post and its comments, including their original trackable type and ID.
- The deleted post disappears from the posts list; its former detail URL returns not found.
- In the global feed, an activity whose Post is missing displays `This post has been deleted`.
- An activity whose Comment is missing displays `This comment has been deleted`.
- Retain actor and timestamp, but display no removed content or link to a missing record.
- Rendering handles a nil trackable without raising an error. Select the event partial using the stored type and action even when the target is missing.
- Do not create a separate deletion Activity. Existing activities display the missing-target message.

## Data model

| Model | Application fields | Relationships |
| --- | --- | --- |
| User | Devise email and password-related fields | Has many posts, comments, and activities |
| Post | title:string, body:text, user_id | Belongs to user; has many comments and activities |
| Comment | body:text, post_id, user_id | Belongs to post and user; has many activities |
| Activity | user_id, action:string, trackable_type:string, trackable_id | Belongs to user and polymorphic trackable |

All tables have a primary key and timestamps. Use the app's default integer IDs consistently.

- Post and Comment declare `has_many :activities, as: :trackable`.
- Activity declares `belongs_to :trackable, polymorphic: true`.
- Add ordinary foreign keys and reference indexes for user and post references.
- Add a composite index on Activity's `trackable_type` and `trackable_id`; it is not unique because a target can conceptually have multiple events.
- Polymorphic targets cannot use a conventional foreign key that switches between posts and comments.
- Require user, action, and trackable reference columns at the database level. Require a valid target when creating an Activity through the model.
- Retaining the reference columns after target deletion allows historical activities to remain while `activity.trackable` returns nil.
- Post destroys its comments, but neither Post nor Comment destroys or nullifies its activities.

## Callback behavior

Each Post and Comment uses `after_create` to call a small private method that creates its Activity through the association with `create!`.

- The content and Activity are written in the same database transaction.
- If Activity creation raises an exception, content creation rolls back.
- Controllers do not also create activities.
- The author is the actor for creation events. No current_user lookup inside models is needed.
- Bulk insertion that bypasses callbacks is outside the supported creation flow.

## Required model test

Write one meaningful Post model test that creates a valid post and verifies:

1. Activity count increases by exactly one.
2. The post has exactly one associated Activity.
3. The Activity user is the post author.
4. The action is `create`.
5. The trackable resolves to the created Post.

Run with `bin/rails test test/models/post_test.rb`. Explain what each assertion proves.

## Manual completion checks

1. Sign in as the first seeded user and create a post.
2. Confirm it appears in the posts list and global feed.
3. Sign in as the second user, read the post, and add a comment.
4. Confirm the post history includes both creation events with the correct actors.
5. Confirm the second user cannot update or delete the first user's post, including direct requests.
6. As the author, edit the post and confirm no extra Activity appears.
7. Delete the post and confirm it and its comments are gone while both activities remain with the specified missing-target messages.
8. Confirm blank content is rejected and does not create activities.
9. Sign out and confirm protected pages require sign-in.

## Implementation sequence

1. Install Devise and generate User; inspect the model, routes, and migration.
2. Generate Post and Comment scaffolds and the Activity model and index controller.
3. Review migrations and indexes together before migrating.
4. Add associations, validations, authentication, ownership checks, and development seed accounts.
5. Write the model test, observe its failure without tracking, and add callbacks to make it pass.
6. Build the post history, global feed, and event partials.
7. Implement deletion behavior and run the manual checks.

## Out of scope

Likes, follows, private posts, notifications, uploads, search, pagination, public registration, account management, comment editing, separate update/delete activities, and production deployment.
