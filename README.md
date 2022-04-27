
<div align="center">
  <h1>NativeTwitch v2</h1>

  <img src="https://user-images.githubusercontent.com/43297314/165196273-24d58da9-05c7-441f-a7a0-ddf845f90d74.png" width="200px">

*Native, Opensource Twitch app for your mac.*


<img src="https://user-images.githubusercontent.com/43297314/165637731-5e9eb88f-fec9-4a53-8011-88cd8b5a5901.png">
  
<img src="https://user-images.githubusercontent.com/43297314/165197169-7231529a-1231-4fe0-a1f6-07571ec898a4.png">


</div>

----

### How to install?

1. [Download the Universal Binary from releases page](https://github.com/Aayush9029/NativeTwitch/releases/download/v4.0/NativeTwitch.app.zip)
2. Install [Home brew](https://brew.sh/) 
3. Install [streamlink](https://github.com/streamlink/streamlink) via ```brew install streamlink```
4. Open app, It's a menu bar app

> Why does this PopUp?
> 
> ![165195528-04b0ff1a-c31b-4b26-bc5a-af4c216308ee](https://user-images.githubusercontent.com/43297314/165195933-2702ffb1-345a-4a49-9dbb-7ea6ad239a54.png)
> 
> *NativeTwitch* saves your access token and client id in Keychain (securely), click Always Allow for ease!
> [See why this is necessary](https://www.reddit.com/r/MacOS/comments/tovph8/why_does_discord_want_to_access_my_keychain_every/)

> Why Generate Oauth? => *This way the app won't need to store your password.*
> 
> Why Streamlink? => *Streamlink handles video pipe (streaming video from twitch's server to your mac) flawlessly.*
>
> Why IINA? => *IINA* handles low latency streams a lot better than quicktime does atm 👌*change streamlink config first*
---

### Check [Releases](https://github.com/Aayush9029/NativeTwitch/releases) for release notes.

---

### How does it work?

1. Uses Twitch Helix api to get list of followed channels
2. Sees if any channels are online
3. If they are and *if you choose to watch* it will stream via [streamlink](https://github.com/streamlink/streamlink).

---

*Legal disclamer: Made for educational purposes only ;)*
