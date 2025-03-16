# Pleny iOS App

This repository contains the solution to the **iOS Software Engineer** interview task for the **Pleny** startup. The app is built using **SwiftUI**, **Combine**, **Core Data**, and follows the **MVVM-C** architecture pattern.

## Project Overview

The Pleny app helps users explore posts related to food experiences. The main features include:
- **User Authentication**: Users can log in to the app using their credentials.
- **Posts Exploration**: Users can view posts in a paginated manner with infinite scrolling.
- **Search Posts**: Users can search for posts and paginate through the search results.
- **Profile and Post Pictures**: Static profile and post images are displayed alongside posts, as per the provided design.
- **Core Data Integration**: Store posts locally to improve app performance and support offline usage.
  
### Technologies Used:
- **SwiftUI**: For building the user interface.
- **Combine**: For reactive programming and handling asynchronous data streams.
- **Core Data**: For local storage and offline caching.
- **MVVM-C**: A combination of **Model-View-ViewModel** and **Coordinator** pattern for clean navigation and separation of concerns.
  
## Features

### Authentication
- **Login**: Users can authenticate using the API provided by **[DummyJSON Authentication API](https://dummyjson.com/docs/auth#login)**.
  
### Posts and Pagination
- **Infinite Scroll**: Users can load posts incrementally with infinite scrolling using **[Posts API](https://dummyjson.com/docs/posts)**.
- **Search Posts**: Users can search for posts using the **[Search Posts API](https://dummyjson.com/docs/posts)**, with pagination in the results.

### Display
- **Post Images**: Each post is displayed with an image from a static source (as per the Figma design).
- **User Profile Pictures**: Profile images for each user are displayed next to their posts, taken from a static image source.

### Unit Testing
- Unit tests are implemented to verify correct behavior for different components of the app.

---

## Installation Instructions

### Requirements:
- **Xcode 13.0** or higher
- **iOS 15.0** or higher

### Clone the repository:
To get started with the project, clone this repository to your local machine:

```bash
git clone https://github.com/Sam1247/Pleny.git
