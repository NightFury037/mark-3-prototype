MARK 3: RISE OF THE OUTCAST — Prototype 0.1

This is a Godot 4 starter project plus a GitHub Actions cloud-build workflow.
It is NOT itself an APK.

PROJECT CONTENTS
- Stylised 3D village made from simple geometry
- Arjun player character and third-person camera
- Touchscreen movement buttons and punch button
- One stationary boss with health and XP reward
- Android export preset
- GitHub Actions workflow intended to build an APK in the cloud

CLOUD BUILD FROM AN ANDROID PHONE
1. Sign in to GitHub or create an account.
2. Create a NEW PUBLIC repository named mark-3-prototype. (Public avoids GitHub Actions availability issues on some accounts; do not upload private information.)
3. Upload all files and folders from this project ZIP to the repository, keeping the .github/workflows/build-android.yml path intact. GitHub's mobile website may be easier in desktop mode; alternatively use GitHub's web upload feature.
4. Open the repository's Actions tab.
5. Select "Build MARK 3 Android APK", then choose "Run workflow" if it has not started automatically.
6. Wait for the workflow to finish. If it succeeds, open the completed run and download the "MARK3-Android-APK" artifact.
7. GitHub downloads artifacts as a ZIP. Extract it on your phone to get MARK3.apk, then install it. Android may ask you to allow installs from that browser/file manager.

IMPORTANT
- The APK is not compiled or tested yet. The workflow is an attempt to build it remotely; it may fail if the hosted build image's Godot/Android export setup differs or if the project has errors. If it fails, share the Actions error log and it can be fixed.
- The workflow creates a temporary debug signing key for testing. Do not use this key for a public release; release signing needs a private, safely stored keystore.
- Prototype visuals are placeholders. No bicycle driving, saved progress, cutscenes, or 20-boss campaign yet.
- Do not publish or distribute this prototype until it has been tested on a real device.
