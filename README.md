# DriveWise

We were inspired by General Motor's prompt to achieve the goal of Zero Crashes, Zero Emissions, and Zero Congestion. Our app was designed to help with all of these areas.

## What it does
DriveWise has three main features:
1. The first is displaying your car's maintenance. By keeping track of your car’s maintenance, you are helping the movement towards zero emissions as well as minimizing the risk of car breakdowns and costly repairs. The maintenance section has three logos. The green check icon means that the car/part has been inspected recently. The yellow warning icon means that that car/part needs to be inspected soon. Finally, The red x means that the car/part needs inspection. In addition, the user has an option to update when they get maintenance, helping them keep track of the cars overall well being.

2. The second is displaying current weather conditions, including the actual weather, the road conditions, and the visibility. By providing you with this information, we make sure that you are prepared in the case that the road conditions aren't ideal or the visibility is low. 

3. The third is a dynamic trip planner, for longer road trips. This feature displays the route, estimated time, distance, suggested rest stops along the way, as well as the weather at these rest stops. The purpose of this is to alert the driver of conditions along the way and eliminate the dangers of drowsy driving.

## How we built it
The app is constructed using Swift and Xcode. We used Visual Crossing API to get real-time weather data for the user's current location, as well as future data for places along a planed trip. We also used MapKit is an Apple Maps API to create and display a route from the user's start location to the user's end location and to suggest rest stops at certain time intervals to reduce drowsy driving.

## Challenges we ran into
Initially, we utilized the Google Maps API to serve the purpose of navigating the user on their journey. However, the API had certain issues when integrating it with an M1 processor Mac, resulting in us having to use the inbuilt MapKit API that was provided by Apple. In addition to that, we had two separate versions of the Swift projects to ensure there were backups in case one were to fail. But eventually we were faced with the situation where we had to merge the two versions of the project and that took several hours to complete. 

## Accomplishments that we're proud of
We were able to integrate MapKit API with Swift to create a route and suggest rest stops. This was a big challenge for us because there was not much documentation when it came to integrating the two. In addition, we didn't think the weather API was feasible, however, we were able to pull it off and make it work.

## What we learned
From a frontend perspective, we learned the importance of UI/UX design, as alot of our time was spent choosing images, colors, fonts, etc, for the app. On the backend side, we learned the intricacies of Swift as it pertained to API integration. We utilized the Visual Crossing API and MapKit API in order to fetch data that was needed. We used MKPoint Annotations to mark the journey check points within the map. Using the MKDrawing canvas tool, we were able to chart a travel journey & find the most convenient rest points to ensure drive safety using other safety metrics.
