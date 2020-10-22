# DEV INSTALLATION GUIDE

> Linux Based

1. Get Flutter tag.gz from https://flutter.dev/docs/get-started/install/linux#install-flutter-manually

2. Unzip it to this folder
   1. It will create a folder named flutter with all the needed binaries 
   2. Folder Structure at this point is:
    ```
    README.md
    > docs
    |   ...
    > guess-it
    |    > flutter
    |    |    |...
    |    |
    |    > guess_it_app
    |    |    |...
    |    INSTRUCTIONS.md
    ```

3. Download Android Studio from https://developer.android.com/studio
4. Install it as https://developer.android.com/studio/install#linux
> Probably won't need to do this: "Se você estiver usando uma versão de 64 bits do Linux, primeiro instale as bibliotecas necessárias para máquinas de 64 bits."

> Mine was installed under `/opt/` folder 
5. Execute `./studio.sh` from directory `android-studio/bin/`, where Android Studio was installed
6. With Android Studio Installed, go to `Configure`, in the bottom right corner and go to `Plugins`.
   1. Search for `Flutter` plugin and install. Android Studio will need a reload.
7. Start a new `Flutter Project -> Flutter Application` just to test.
   1. Point `Flutter SDK` to the `flutter` folder in this repository
   2. Save the new project under your machine's `/tmp/` folder - as, in this moment, is just for testing.
   3. Create it!
   4. It will do a lot of stuff. Wait...
   5. When you feel it is quiet and not doing shit, at the top where it may say there are no devices connected, search for an emulator and select it. It will start an Emulated Phone. If you see a Phone but it does not turn on, click on the power button at the left side, before the volume button.
   6. Click Run! Wait for the emulated Phone to start and to start the app.
   7. Play with it and with the code. There is the Hot Reload option, so if you change the code and Ctrl+S it will automatically update the Phone App.
8. Close that shitty project and open ours here at `guess-it/guess_it_app`