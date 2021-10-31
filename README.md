# NativeTwitch
Native Twitch Player

----

App Screenshots

<img src="https://raw.githubusercontent.com/Aayush9029/NativeTwitch/main/assets/ryan.png"> <img src="https://raw.githubusercontent.com/Aayush9029/NativeTwitch/main/assets/sykk.png">



---

### How to install?

1. [Download the Universal Binary from releases page](https://github.com/Aayush9029/NativeTwitch/releases/download/v4.0/NativeTwitch.app.zip)
2. Install [Home brew](https://brew.sh/) 
3. Install [streamlink](https://github.com/streamlink/streamlink) via ```brew install streamlink```
4. Open app preferences, `Command + ,`
5. Generate ClientID and Access Token via [twitchtokengenerator.com](https://twitchtokengenerator.com/quick/NIaMdzGYBR)
6. Find streamlink installed location via ```which streamlink``` and paste it in field named Stream link location.



> Why Generate Oauth? => *This way the app won't need to store your password.*
>
> Why Streamlink? => *Streamlink handles video pipe (streaming video from twitch's server to your mac) flawlessly.*

---

### Check [Releases](https://github.com/Aayush9029/NativeTwitch/releases) for release notes.

---

### How does it work?

1. Uses Twitch Helix api to get list of followed channels
2. Sees if any channels are online
3. If they are and *if you choose to watch* it will stream via [streamlink](https://github.com/streamlink/streamlink).
