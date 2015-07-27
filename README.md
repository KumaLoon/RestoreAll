# RestoreAll

Back up and restore things from your jailbroken device

I will be putting files that are being tested. 

# License

GPL V3 License

# Release Note
This is still in beta.
- Issues:
<<<<<<< Updated upstream
	- Restoring Library is disabled in this version
	- Because iTunes’ encode musics (FairPlay?), this tool doesn’t back up Music perfectly, all the music are present but may have some musics that are missing names.
	- Restoring Cydia Packages may fail
	- Backing up Library may break Cydia. (Move the /var/mobile/Caches back to /var/mobile/Library to fix this)
- Note:
	- Backing up Apple Music will not be a thing in this tool. 
    - After restoring SMS and Photos, you have to do a manual reboot (shut down and boot)
	- If SSH verification shows warning, check “~/.ssh/known_hosts”
	- Build-In update system will be available soon.
=======
    - Restoring Library is disabled in this version, you can preview what’s going to be included.
    - During the file transfer, device may halt when screen is locked. (Workaround: Turn off auto-lock or plug your device to charger.)
    - Restoring Cydia packages may fail (Still working on this one)
- Note:
    - Backing up Apple Music will not be a thing in this tool.
    - Because iTunes’ encoded musics and videos, this tool doesn’t back up things perfectly, all the 	things are present but may have some things that are missing names.
    - After restoring SMS and Photos, you have to do a manual reboot (shut down and boot)
	- Build-In update system will be available soon. (or not)
>>>>>>> Stashed changes
	- This DOES back up and restore Cydia repos, but doesn’t add the sources to the Cydia 1.1.10 or above. Which means it does download everything from those repos but not listed in the Cydia.

# Important Note
This program will NOT save nor show your password to anyone including you.

You should NEVER trust any other versions of RestoreAll from any unknown sites (Like sites that are not verified by LooneySJ.)

Beta Version cannot guarantee a successful result, USE IT AT YOUR OWN RISK.
