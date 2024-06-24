# AP Test Analysis

## Introduction

### Purpose
To determine the state of the AP Program, an analysis was performed to explore student participation, success, and any notable trends within the program.

### Aims
Data visualization will be used to:
1. Explore the pass rates of AP test takers overall, across subject areas, and compared to last year.
2. Compare the participation rate vs. participation goals.
3. Determine the effectiveness of interim exams to predict student outcomes.
4. Explore the effect of a student's level of participation in AP exams on their success.
5. Identify any notable anomalies.

## Project Layout

This project is organized as follows:

- **R file**: Contains the R code for generating visualizations.
- **Markdown file**: Used to knit together the visuals and observations into a single document.
- **HTML file**: The final output of the analysis, which can be downloaded and viewed in a browser to see the complete results.

## Analysis

### AP Pass Rate
A distribution of AP scores indicates limited success for our AP test takers. Distributions across all subject areas are skewed right, with AP Language Arts having the highest success and AP Calculus the lowest.

- A look at the overall pass/fail and across subject areas shows a low rate of success for this year, with AP Language Arts showing the best pass rate at 47%. All other courses failed to cross the 35% mark, with AP Calculus not having any students pass the exam this year.
- A clear down trend in pass rates can be seen when compared to the previous year’s pass rates.

### AP Interims & AP Pass Rates
Exploring the predicted scores from the AP Interim test compared to a student’s actual result appears to be a mixed bag. When a student takes the test, about 66% are correctly predicted. However, a relatively large number of students were predicted to pass but failed. This group makes up the majority of the incorrectly predicted test takers. Including the students who did not participate because they were predicted to be below AP3, it appears likely that the interim exam is a good indicator.

### Quantity of Tests Taken vs. Student Success
Another possible indicator of student success is the number of AP tests a student attempts. There doesn’t appear to be any clear relationship between the number of tests taken and the number passed. The plot below indicates that students taking 3 tests were the most likely to pass at least one test. Contrarily, taking 2 AP tests had fewer pass at least one test than just taking a single test. The Pearson correlation (0.43) supports the conclusion of a small but unreliable relationship between tests taken and the number of tests passed. Further exploration of possible lurking variables should also be conducted.

### Participation Rate
Participation rates are far below the goal of 65%. The closest to that goal (AP Gov) was 36 points below the mark. The same trend is seen for the index goal.

## Conclusions
Given the significant drop in all metrics for the AP exam, it is suspected that there has been a significant change to the AP exams or the school. The drop in metrics is likely related to Covid policies and residual effects. Further comparison of participation rates, pass rates, and predicted actual scores to rates before Covid-19 and in future years is recommended.

## Author
Michael Brakenhoff  
2023-03-22
