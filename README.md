# Team Oman

Features:
1. Initial Setup: Users will be sent to an app sign-up/log-in page where they can create an account and account details, credentials, and API tokens will be stored on Firebase.
Sign Up/Sign In page
UX and UI Setup
Goal Setting: On initial setup, users should be able to set an ideal amount of goals and cadence at which to receive them. Overwriting should be enabled
Notifications: The user should be able to enable or disable notifications from the app about goals, streaks, etc
2.  App Entry: It will upon login, query the user’s current emotional status to get a gauge for the advisor and in the case that the user selects a “1” on the [1,2,3,4,5] scale with 1 being = terrible, and 5 = good, it will prompt the user to chat with Emotional  Coach..
Emotional Status Query (jump to Emotional Coack if mood ==1)
3. Dashboard: Then the user will have access to a dashboard with buttons to “Past Entries”, “New Entry”, “CHAT”, or “Goals”.
UI: Logo somewhere on the screen with potentially a streak?
Buttons: “Past Entries”, “New Entry”, “CHAT”, or “Goals”.
4. Goals: It will also allow the user to set weekly or daily goals centered around their entries. It will also include a checklist and “check-in” on the user using notifications depending on the cadence at which the user set.
Goal Settings: On initial setup, users should be able to set an ideal amount of goals and cadence at which to receive them. Overwriting should be enabled
5. Past Entries: Past entries will include a list of all entries and the option to continue chatting or see past goals set with that entry. In this continued chat, the advisor would reference what was talked about that day and allow users to continue the conversation.
Search Setting: Should include a search setting and a calendar to see which dates the user talked/used the
Streak Bonus: Should have a streak feature…….
6. New Entry: This will take the user to a note-pad-esque screen where Users can type out notes: ideas, feelings, thoughts etc. Once they hit the done button, two options will appear on the screen which will allow users to “SET GOALS” or “CHAT”
SET GOALS: Will use a prompt determined by us and GPT API to set goals based on the number the user specified and will add to either daily goals or “weakly” goals.
7.Final API Integration: Instead of creating a Chat Feature and self-set goals, users are allowed to generate goals after filling out an entry using a connection to the Open AI text generation API. As opposed to specifically tailored coaches, the integration gives you goals including a difficulty level, as well as a 2-3 sentence blurb describing the tangible goal.

Video Link: https://www.youtube.com/watch?v=4KO7xLrkXas

Powerpoint Presentation: https://docs.google.com/file/d/1Jzs21Mz6fS-tuGUHAM4MXIUQuKki22NU/edit?usp=docslist_api&filetype=mspresentation 
