/* In this SQL project, I am acting as a Data Analyst for an eCommerce company - Mavenfuzzyfactory - who just launched its first product. */

/* I am working directly with the CEO, Marketing Manager and Website Manager of the company to help them understand where traffic is coming from, how it is performing in terms of volume and conversion rate. */

/* I am also helping them to understand what should be the right amount of bid for various segments of paid traffic, based on how well they are performing and how much revenue they are able to generate. */

/* The company's database has over 1.7 million rows of data, divided into six essential tables about website activity, website traffic, products, orders, and refunds. */

/* Before diving in, I would like to briefly introduce some marketing buzzwords: UTM tracking parameter */

/* Paid traffic is commonly tagged with tracking (UTM) parameters, which are appended to URLs. It allows the company to tie website activity back to specific traffic sources and campaigns.
www.abcwebsite.com?utm_source=trafficSource&utm_campaign=campaignName
In the above URL, “?” tells the browser that everything coming next is NOT going to impact where the browser should look to find the page. It is simply on there for tracking purposes */

/* In our database, We have UTM sources: include gsearch(Google) and bsearch(Bing).
UTM campaigns: include nonbrand and brand. The nonbrand group are people looking for a product category i.e. “Teddy Bears”, “ Buy Toys Online”, etc. The brand group are people searching for your company specifically by name i.e. “Maven”, “Fuzzy Factory”.
UTM contents: include g_ad_1, g_ad_2, b_ad_1, b_ad_2. A lot of places will use utm content to store the name of a specific ad unit that they’re running. */

/* In my role as a data analyst, I will extract and analyse requests from the company's CEO, marketing managers, and website managers. */

/* 
From: CEO
Subject: Website traffic breakdown
Date: April 12, 2012

We’ve been live for almost a month now and we’re starting to generate sales.
Can you help me understand where the bulk of our website sessions are coming from, through yesterday?
I’d like to see a breakdown by source, campaign and referring domain.
*/


SELECT utm_source, utm_campaign, http_referer,
COUNT(DISTINCT website_session_id) AS sessions_volume
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY sessions_volume DESC;


/*
# utm_source, utm_campaign, http_referer, sessions_volume
'gsearch', 'nonbrand', 'https://www.gsearch.com', '3613'
NULL, NULL, NULL, '28'
NULL, NULL, 'https://www.gsearch.com', '27'
'gsearch', 'brand', 'https://www.gsearch.com', '26'
NULL, NULL, 'https://www.bsearch.com', '7'
'bsearch', 'brand', 'https://www.bsearch.com', '7'
*/

-- It is conclude that gsearch and nonbrand are driving more traffic volume than any other campaign or sources for the period until the 12th of April 2012.

/* Received a second request from Marketing Director */
 /* 
From: Marketing Director
Subject: Gsearch conversions
Date: April 14, 2012

Looks like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from session to order? Based on what we’re paying for clicks, we’ll need a CVR of at least 4% to make the numbers work.  */


SELECT
COUNT(DISTINCT website_sessions.website_session_id) AS sessions_volume,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id)*100 AS conversion_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
AND website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY conversion_rate DESC;


/*
# sessions_volume, orders, conversion_rate
'3895', '112', '2.8755'
*/

-- It is concluded that the conversion rate is of 2.9% means the gsearch nonbrand bids are not driving sales as expected, the investment is not working the best way. 

-- Another request came from the Marketing Director

/*
From: Marketing Director
Subject: Gsearch volume trends
Date: May 10, 2012

Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012–04–15.
Can you pull gsearch nonbrand trended session volume, breakdown by week, to see if the bid changes have caused volume to drop at all?
*/


SELECT
YEAR(created_at) AS year,
WEEK(created_at) AS week,
MIN(DATE(created_at)) AS week_start_date,
COUNT(website_session_id) AS visits_volume
FROM website_sessions
WHERE created_at < '2012-05-10'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY 1,2;


-- According to the analysis, It is confirmed that After the 15th of April, it is confirmed that the traffic for gsearch nonbrand has considerably dropped.

-- Another request received from Markeeting Director

/*
From: Marketing Director
Subject: Gsearch device-level performance
Date: May 11, 2012

I was trying to use our site on my mobile the other day, and the experience was not great.
Could you pull conversion rates from session to order, by device type?
If desktop performance is better than on mobile we may be able to bid up for desktop specifically to get more volume?
*/


SELECT website_sessions.device_type,
COUNT(website_sessions.website_session_id) AS sessions,
COUNT(orders.order_id) AS orders,
COUNT(orders.order_id)/COUNT(website_sessions.website_session_id)*100 AS session_to_order_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE utm_source = 'gsearch' AND utm_campaign = 'nonbrand' AND website_sessions.created_at < '2012-05-11'
GROUP BY 1;


-- It is concluded that Desktop is performing a way lot better, therefore we should rise the bids for this type of device to increase volume.

-- Another request received from Marketing Director

/*
From: Marketing Director
Subject: Gsearch device-level trends
Date: June 09, 2012

After your device-level analysis of conversion rates, we realized desktop was doing well, so we bid our gsearch nonbrand desktop campaigns up on 2012–05–19.
Could you pull weekly trends for both desktop and mobile so we can the impact on volume?
You can use 2012–04–15 until the bid change as a baseline.
*/


SELECT 
YEAR(created_at) AS year,
WEEK(created_at) AS week,
MIN(DATE(created_at)) AS week_start_date,
COUNT(CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) AS mobile_volume,
COUNT(CASE WHEN device_type='desktop' THEN website_session_id ELSE NULL END) AS desktop_volume
FROM website_sessions
WHERE created_at < '2012-06-09'
AND created_at > '2012-04-15'
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY 2;


-- It is seen that the traffic volume for gsearch nonbrand desktop has increased from the 15th of April up to date

/*
Project Conclusion
Traffic source analysis is about understanding where the customers are coming from and which channels are driving the highest quality traffic.

Analyzing for bid optimization is about understanding the value of various segments of paid traffic, so that we can optimize the marketing budget.

In a marketer perspective, the goal is to generate volume and drive more traffic to the website and make more money to the business.

On the analytics side, the mission is to analyse the traffic sources and bid optimization to understand the value of various segments of paid traffic, improving the marketing budget.
*/




