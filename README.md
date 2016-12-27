Data Science Capstone Project
================
Balogun Stephen Taiye
December 26, 2016

Introduction
============

This repository describes the activities of the Coursera Data Science Specialization Capstone project offered by the John Hopkins Bloomberg School of Public Health.

The capstone project is a collaboration between John Hopkins and [SwiftKey](https://swiftkey.com/en). It involves building a predictive text model using natural language processing (NLP).

The data for the project is from a corpus called [HC Corpora](www.corpora.heliohost.org).

Activities
==========

The tasks accomplished include:

Obtaining the data
------------------

1.  downloading the [data](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)

2.  Loading/manipulating it in R.

3.  Getting familiar with NLP and text mining - Learn about the basics of natural language processing and how it relates to the data science process.

Tokenization
------------

1.  identifying appropriate tokens such as words, punctuation, and numbers.

2.  Writing a function that takes a file as input and returns a tokenized version of it thereby creating **n-grams**.

3.  Profanity filtering - removing profanity and other words you do not want to predict.

Build a predictive model
------------------------

1.  Creating a predictive model based on the previous data modeling steps

2.  Evaluating the model for efficiency and accuracy.

Create Data products
--------------------

1.  Build a [shinyApp]() that takes as input a phrase (multiple words) in a text box input and outputs a prediction of the next word.

2.  A slide deck consisting of no more than 5 slides created with [R Studio Presenter](https://support.rstudio.com/hc/en-us/articles/200486468-Authoring-R-Presentations).

Packages used
=============

The following packages were used to complete the various activities:

1.  [`tm`](http://www.jstatsoft.org/v25/i05/)

2.  [`tidyverse`](https://CRAN.R-project.org/package=tidyverse)

3.  [`ANLP`](https://CRAN.R-project.org/package=ANLP)

4.  [`tidytext`](http://dx.doi.org/10.21105/joss.00037)

5.  [`doParallel`](https://CRAN.R-project.org/package=doParallel)

6.  [`dplyr`](https://CRAN.R-project.org/package=dplyr)

Organization of the repository
==============================

1.  The initial activities (downloading, exploration and initial tokenization ) were conducted using the five `"*script*.R"`.

2.  The `milestone_report` folder contains the complete files for the milestone report

3.  The final activities (final tokenization, prediction model, testing and validating the model) are contained in the `prediction.R` and the `validation.R` files.

4.  The `next-word prediction` app is located here on [shinyApp](https://stbalo2002.shinyapps.io/datascience_capstone_project/)

@ The presentation is available on [rpub](http://rpubs.com/stbalo2002/datascience_capstone_project)
