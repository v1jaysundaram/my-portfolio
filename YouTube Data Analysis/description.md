# YouTube Data Analysis

_This directory contains the notebook with code, dataset(s), and a PowerPoint file. For a detailed explanation of the code, check out the [Medium](https://medium.com/@vijay_sundaram/analysing-popular-travel-youtubers-an-eda-project-using-youtube-video-data-in-python-298910922603) blog._


## Description
The project aims to analyse the YouTube video data of travel YouTubers and identify the factors that make a video perform well on YouTube. Additionally, it aims to explore the trending topics of the videos in this niche using Natural Language Processing (NLP).

## Technologies / Libraries Used:
- Python
- pandas
- NumPy
- Matplotlib
- seaborn
- Plotly
- NLTK

## Data Dictionary
The “video_df” dataframe comprises 1446 rows and 12 columns.

| Variable     | Description                                            |
|:------------:|:------------------------------------------------------:|
| video_id     | Unique identifier for each video                       |
| channelTitle | Title of the YouTube channel associated with the video |
| title        | Title of the video                                     |
| description  | Textual description provided for the video             |
| tags         | Keywords or labels associated with the video           |
| publishedAt  | Date and time when the video was published             |
| viewCount    | Number of views the video has received                 |
| likeCount    | Number of likes the video has received                 |
| commentCount | Number of comments posted on the video                 |
| duration     | Duration or length of the video                        |
| definition   | Video resolution or quality                            |
| caption      | Indicates whether captions are available for the video |

<!-- Leave a line here -->

The “comments_df” dataframe has 1323 rows and 2 columns.

| Variable |                                      Description                                      |
|:--------:|:-------------------------------------------------------------------------------------:|
| video_id | unique identifier for each video, linking it to the corresponding video in `video_df` |
| comments | textual content of comments posted on the associated video                            |

## Results
Analyzed travel YouTube channels for view distribution, engagement rates, video interactions, title characteristics, video duration, publishing times, and trending topics.
