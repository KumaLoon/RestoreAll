# RestoreAll

Back up and restore things from your jailbroken device

I will be putting files that are being tested. 

# License

GPL V3 License

# Release Note
This is still in beta.
- Issues:
    - Restoring Library is partially enabled in this version, you can use the feature but most of them 	are broken. If you did an update your device, please don’t restore library because it may break your device.
    - During the file transfer, SCP halts when screen is locked. (Workaround: Turn off auto-lock or plug your device to charger.)
    - In some cases, Cydia will not start up after the backup. (Workaround: Reinstall Cydia with SSH.)
- Note:
    - Backing up Apple Music will not be a thing in this tool.
    - Because iTunes’ encoded musics and videos, this tool doesn’t back up things perfectly, all the 	things are present but may have some things that are missing names.
    - After restoring SMS and Photos, you have to do a manual reboot (shut down and boot)
	- This DOES back up and restore Cydia repos, but doesn’t add the sources to the Cydia 1.1.10 or above. Which means it does download everything from those repos but not listed in the Cydia.

# Important Note

This program will NOT save nor show your password to anyone including you.

You should NEVER trust any other versions of RestoreAll from any unknown sites (Like sites that are not verified by LooneySJ.)

Beta Version cannot guarantee a successful result, USE IT AT YOUR OWN RISK.

# About the "Restore Library" feature
So, let’s talk about the library restore feature. I listed all the items in library to test out if any files break the whole system. I found out that there were some files that killed the whole system because it’s either the version is not compatible with the files or the device itself is not optimized for that file. I think in 2 or 3 weeks, I will add a script to check the version and device to minimize the crashes. I will also test backward compatibility down to iOS 5.
