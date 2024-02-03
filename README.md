# Data Skills 2 - R
## Winter Quarter 2024

## Homework 3
## Due: February 22 before midnight on GitHub Classroom

__Question 1 (30%):__ You are working as a research assistant at a think tank that works on global public health.  The senior researcher you work for tries to follow the Public Health Roundup from [the WHO Bulletin](https://www.who.int/publications/journals/bulletin), but they have been too busy lately to keep up with it.. They ask you to read in the January 2023 report (from the text file included in the repo, also available [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9795377/) and parse it using natural language processing:

Describe the sentiment of the article, and show which countries are discussed in the article. For at least one of the countries, plot a dependency parse to depict what was said about that country.

Output to save to your repo for this question:
  * question1.R file with the code - summary statistics can be displayed with print or View
  * question1_plot_X.png file for the plots you generate (a minimum of 2, a maximum of 4)

__Question 2 (70%):__ Your senior researcher is very happy with the results you achieved on the most recent report, so they ask you to generalize your code to parse more of the newsletters.  The links to the past issues are [here](https://www.ncbi.nlm.nih.gov/pmc/journals/522/). You should be able to click through to get to the Public Health Roundup for each volume. Use basic web scraping to collect every in volume 101 (from 2023). Try your best to capture only text, and not any extraneous components such as URLs, references to photos, etc.

Do not use the text file from question 1, but do reuse as much code as you can from question 1 (i.e. copy and paste any relevant code from question 1 and then change it to generalize).  Keep in mind that your code for question 2 needs to potentially be able to generalize to more than the volumes/years specified, so good generalization is crucial.  Note that any slight variation in results from the text file in question 1 and the parsed html content for question 2 is acceptable, due to differences in the web formatting.

Now, depict how the overall sentiment and countries discussed in the Public Health Roundup changes. (Hint: see the `is_country` function in the "[countries]([url](https://cran.r-project.org/web/packages/countries/readme/README.html))" package)Characterize how the overall sentiment, or the sentiment related to a particular topic, changed over time. For at least one of the countries that shows up in more than one report, plot a dependency parse to depict what was said about that country in different reports.

Output to save to your repo for this question:
  * question2.R file with the code - summary statistics can be displayed with print or View
  * A file (or collection of text documents) of the text from the reports that you scraped.
  * question2_plot_X.png files for the plot(s) you generate (a minimum of 2, a maximum of 4)

Note that there is a lot of flexibility in how you approach these questions and what your final results will look like.  Being comfortable with that sort of assignment is an explicit course goal; real-world research is much more likely to come with open-ended assignments rather than explicit direction to start with X and accomplish exactly Y.  Use short comments (1-3 lines max) to explain any choices that you think need explaining.  Remember wherever possible to focus on "why" in your comments, and not "what". As usual, include a README file describing the code and output.
