
<div data-align="center">

<p align="center">

<img src="inst/app/www/cRew_iphone.png"  align=center>

</p>

</div>

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Join the cRew

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

**c**o**R**anavirus **e**arly-**w**arning (**cRew**) App tracks Covid-19
/ flu like disease symptoms in real-time. The goal of cRew is to map in
real-time healthy and symptomatic people. As users enter data about
their health status, the app monitors temporal and spatial changes and
estimates sudden increases or decreases on local risks. **Experimental
use only.**

User input parameters are based on health (fever, coughing, breathing
problems), behavioral (such as going outside, staying home and wearing
mask) and location based.

The app is built with
[shinyMobile](https://rinterface.github.io/shinyMobile/) &
[firebase](https://firebase.john-coene.com/),
[echarts4r](https://echarts4r.john-coene.com/) and
[fireData](https://github.com/Kohze/fireData)

## About

The app uses Google firebase authentication. This ensures that only
authenticated users are able to interact with the app. Firebase
authentication and User specific data access is established through the
[firebase R package](https://firebase.john-coene.com/) from John Coene
and setting up firebase Database rules [(More
information)](https://firebase.google.com/docs/database/security/quickstart?authuser=0).

Features:

  - User data are saved to Google **Firebase real-time database.**
      - as collections **in user-specific folders.** This is achieved
        through the use of variables created during the authentication.

Two variables are used:

  - **uid**: The user ID, unique to the Firebase project. Generated
    during authentication. This is used to create a **user specific
    directory** in firebase database.

access uid in Shiny/firebase app by **f$signed\_in$response$uid**

  - **token**: The Token generated during user authentication

access the token in Shiny/firebase app by
**f$signed\_in$response$stsTokenManager$accessToken**

Example:

``` r
 fireData::upload(x = user_inputs, 
                projectURL = databaseURL,
                directory = paste0("fire/",uid()), # Combine your target directory with uid
                token=token())  # Add token information
```

The second part requires to correctly setup google firebase rules. [More
information](https://firebase.google.com/docs/database/security/quickstart?authuser=0).

For example following rules allow only authenticated users to can read
data and only save data under their user-specific folder in the
database.

``` r
# Example rules to specify that user data can be saved only at a user specific node
# in the database (here 'fire/uid' directory).

{
  "rules": {
    ".read": "auth.uid != null",
    ".write": false,
    "fire":{
      "$uid": {
        ".write": "auth.uid === $uid"
      }
    }
  }
}
```

  - Users can access their past inputs from the My history tab.
  - Server methods allows only authenticated users to see the plots
    (e.g. f$req\_sign\_in() needs to be TRUE)

## cRew App

You can access the app here \>\> [cRew symptom
Tracker](http://tools.dataatomic.com/shiny/cRew)

The app is for experimental purposes and the disease risk estimation via
the app are calculated by the users who enter values thus can be biased.

``` r
# install.packages("remotes")
remotes::install_github("korur/cRew")
```

## Set up and run

The code for the app is available as an R package cRew. You can deploy
and connect to your own database and run it with your modifications and
track other symptoms/diseases.

``` r
# Setting up with your firebase database
firebase::create_config(api_key = "yourfirebase apiKey, project_id = "your firebase projectId")
databaseURL <- "your firebase databaseURL"
# Run the app
cRew::run_app()
```
