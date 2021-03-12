# FeelApp

It is the music application. It contains that:
- All music in application seperated emotion according to accustics. And the user can search music with saying their current emotion.
- The application finds the currently playing music and opens that music video.
- The application contains some radio seperated emotions and the user can see what the currently music in the radio.
- The user can playing music game (10 questions, 90 minutes).
- The user can like, delete, search and listen music anytime.

The application uses MySql for saving user credential data(password,email,name and profile picture) and the selected emotions (calm,energetic,joyful,dreamy) musics and also liked, last, searched musics lastly date the user first entered. The application takes music, album, artist and game question datas from according to each of JSON files. The application written in MVC pattern.

The application uses some libraries:

  - speech_to_text: ^2.4.1
  - flutter_acrcloud: ^0.0.1
  - mysql1: ^0.17.1
  - rflutter_alert: ^1.0.3
  - provider: ^4.0.4
  - http: ^0.12.2
  - google_sign_in: ^4.5.6
  - just_audio: ^0.3.3
  - webview_flutter: ^0.3.3
  - flutter_signin_button: ^1.1.0
  - string_similarity: ^1.1.0
  - path: ^1.7.0
  - mailer: ^3.2.1
  - shared_preferences: any
  - splashscreen: ^1.3.5
  - solid_bottom_sheet: ^0.1.9
  - simple_animations: ^1.3.4
  - flutter_facebook_auth: ^1.0.2+2
  - youtube_api: ^0.8.0
  - flutter_speed_dial: ^1.2.5
  encrypt: ^4.1.0

