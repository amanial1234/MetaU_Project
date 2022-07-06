#  AMAN ABRAHAM  METAU_Project

# MUSIC TASTE

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Timeline](#Timeline)
1. [Wireframes](#Wireframes)

## Overview
### Description
This app is designed to be a matchmaking app for individuals with similar music taste. Our targeted audience will be teens to young adults that want to connect with individuals with similar music taste. Our goal is to meet the needs of this audience by providing an app that has an advanced matchmaking algorithm and easy to use UI that will make it simple to find individuals that like the same music as the user.



### App Evaluation
- **Category:** Music/Social Media
- **Story:** Analyzes users' music choices, and connects them to other users with similar music taste.
- **Market:** Any individual could choose to use this app, but the app is primarily made for young adults that connect easier with people with similar music taste. 
- **Habit:** This app could be used as often or unoften as the user wanted, similar to most dating apps
- **Scope:** First I would like a few test users on a spotify Api but manage to expand into other apis such as Apple Music and Pandora. 

## Product Spec
### 1. User Stories (Required and Optional)

**Required**

*Gesture on cell (left or right)  
*Algorithm(artists, music genre, and songs)
*Matchmaking View
*Login View
*Profile View


**Stretch**

*Other variables in algorithm (bpm, friends music taste, dance ability) 
*Messaging(details View)
*Details View


### 2. Screen Archetypes

* Login/Register using a database to store users
* Profile Screen 
   *  This is where they are able to edit there Profile. Add a Bio, send links to their playlists and add profile images.
* MatchMaking Screen.
   * MatchmakingView which will have all the potential matches for the users. The potential matches will be placed in descending order where the most likely match will be the top cell. The order is determined by an in depth algorithm that finds best suitable depending on different variables such as genre, artists, albums,and songs the user listens to. There will be cells that hold the matches info such as: name, profile image, favorite song, favorite artist, and favorite genre. The user will then be able to use a gesture of swiping left or right on the cell to accept the match or decline.listening and interacting with others.

#### Optional
* Messaging Screen - Chat for users to communicate (direct 1-on-1)
   * Upon selecting music choice users matched and message screen opens

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Matchmaking
* Profile
* Login

Optional:
* Messaging
* Details Messaging

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Profile -> Text field to be modified. 

### 4. Timeline

**1st Week**  

* Wireframe(create all screens and cells)  
* Login Screen
* Develop Matchmaking Screen
* Develop plan for Algorithm

**2nd Week**  

* Implement Algorithm
* Create Custom Gesture
* Forced Login

**3rd Week**  

* Create Bio Page
* Create Profile Page

**4th Week** 
* Messaging Page
* Messaging
* Liking Message
* Implement more vairables in algorithm

## Wireframes

### Main  
<img width="593" alt="MT_Main" src="https://user-images.githubusercontent.com/103143506/176749661-9234334d-cc50-4e05-abe1-39cba9d4cc74.png">  

### Stretch  
<img width="505" alt="MT_messaging" src="https://user-images.githubusercontent.com/103143506/176749732-8ff08d66-5c24-4906-9351-32e6ebc81753.png">

Information on the API - https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks


