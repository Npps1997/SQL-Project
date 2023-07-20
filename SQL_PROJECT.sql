-- 1. E-R Diagram--> Database >> Reverse Engineer >> Select DB

-- 2. We Want to reward the user who has been around the longest, Find the oldest users.

Select * from users
order by created_at limit 5;

-- 3. To target inactive users in an email ad campaign, find the users who have never posted a photo.

SELECT id, username FROM USERS
WHERE id NOT IN (SELECT User_id from PHOTOS);


SELECT users.id, users.username
FROM users
LEFT JOIN photos
	ON users.id=photos.user_id
WHERE photos.id IS NULL;

-- 4. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won ?

SELECT u.id as user_id, u.username as username, p.id as photo_id, p.image_url, count(L.user_id) as Userlikes from users u
INNER JOIN photos p ON u.id = p.user_id
INNER JOIN likes L ON p.id = L.photo_id
group by p.id
order by Userlikes desc
LIMIT 1;

-- 5. The investers want to know how many times does the average user post.

WITH POST_COUNT AS
(Select Users.id AS USERID, count(photos.user_id) AS POST_COUNT from users
INNER JOIN photos ON users.id = photos.user_id
GROUP BY USERS.ID)
SELECT AVG(POST_COUNT) AS AVERAGE_POST_COUNT_PER_USER FROM POST_COUNT;

SELECT ROUND(
( SELECT COUNT(*) FROM photos ) / ( SELECT COUNT(*) FROM users ),2)
AS avg_user_post;

-- 6. A brand wants to know which hashtag to use in a post, find the top 5 most used hashtags.

SELECT tags.id, tags.tag_name, count(photo_tags.tag_id) as tag_count from tags
INNER JOIN photo_tags on tags.id = photo_tags.tag_id
group by tags.id
order by tag_count desc
limit 5;

-- 7. To find out if there are bots, find users who have liked every single photo on the site.

Select users.id, users.username, count(*) as Userlikes_on_photo from Users
INNER JOIN likes on users.id = likes.user_id
group by users.id
having Userlikes_on_photo = (Select count(*) from photos);

-- 8. Find the users who have created instagramid in may and select top 5 newest joinees from it ?

Select id, username from users
Where month(created_at) = 5
order by created_at DESC
limit 5;

-- 9. Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos.

Select distinct(users.id), (users.username) from users
INNER JOIN photos ON users.id = photos.user_id
inner join likes ON photos.user_id = likes.user_id
Where username regexp '^c.*[0-9]$';

-- 10. Demonstrate the top 30 user names to the company who have posted photos in the range of 3 AND 5.

Select users.username, count(photos.id) as photos_Posted from users
INNER JOIN photos ON users.id = photos.user_id
group by users.id
having photos_Posted between 3 and 5
order by photos_Posted desc
limit 30;



