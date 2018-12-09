NLP Capstone, Text Prediction
========================================================
author: by Nick
date: 9/12/2018
autosize: true


The User App
========================================================

![alt text](screen2.jpg)
***
The text prediction app has two user inputs: 
- The slider on the left chooses how many predicted words to choose, in this case the top 5 options are displayed (note: the most likely predicted word is at the top of the table)
- The text input box is where enter your text

Below the Input box, the predictions will be shown and updated as you type.

Links to the App
========================================================

The app can be found at the address below:

https://nick3112.shinyapps.io/Text_Predict/

The interim report detailing the main steps in data preparation and expected modelling process can be seen here:

https://nick3112.github.io/NLPcapstone/Interim_Report_knit.html

Further details in the process are noted on the next slide

How the App Words
========================================================

As the user inputs text, the app looks through a repository of n-grams (such as the 4-gram "for me at kick") to find a match and predict the next word in the n-gram. The database for the 4-grams is created by deconstructing a 5-gram so that the prediction can be found (in this case "for me at kick" would have the result "boxing").  Where multiple matchers are found, the matches are ordered in highest frequency to give the best chance of prediction.  

For example the sentence:  "The end of the" produces lots of matches in the 5-grams:

 - "the end of the day"  - 0.024% of the observed (the maximum)
 - "the end of the year" - 0.018% of the oberved

In the 4-grams, the results are the same but the probabilities lower and so are ordered lower in the results table.


Potential Improvements
========================================================

Given further development some improvements could be made 

- Remove more spurious words from the results to imrpove speed
- More care over contractions to ensure they can be re-built in the final app
- Out-sample testing of the parameters of the Katz-Backoff model to improve results
- Split n-grams between questions and statements
- look at sentiment analysis to create more accurate prediction (happy/sad/angry statements with different prediction)
- take more care over punctuation removal; separate new sentences onto new lines
