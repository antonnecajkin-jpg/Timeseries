SELECT course_info, unique_users, lessons_count, total_views, avg_views_per_user, last_viewed_at, first_viewed_at
FROM public.course_summary;

SELECT total_users, total_courses, total_lessons, users_with_views, avg_lessons_per_course, avg_views_per_lesson
FROM public.platform_summary;