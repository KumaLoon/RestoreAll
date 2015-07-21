# RestoreAll

Back up and restore things from your jailbroken device

I will be putting files that are being tested. 

# License

MIT License

# Release Note
This is still in beta.
- Issues:
	- Restoring Library is disabled in this version
	- Because iTunes’ encode musics (FairPlay?), this tool doesn’t back up Music perfectly, all the music are present but may have some musics that are missing names.
	- Restoring Cydia Packages may fail
	- Backing up Library may break Cydia. (Move the /var/mobile/Caches back to /var/mobile/Library to fix this)
- Note:
	- Backing up Apple Music will not be a thing in this tool. 
    - After restoring SMS and Photos, you have to do a manual reboot (shut down and boot)
	- If SSH verification shows warning, check “~/.ssh/known_hosts”
	- Build-In update system will be available soon.
	- This DOES back up and restore Cydia repos, but doesn’t add the sources to the Cydia 1.1.10 or above. Which means it does download everything from those repos but not listed in the Cydia.

# Important Note
This program will NOT save nor show your password to anyone including you.

You should NEVER trust any other versions of RestoreAll from any unknown sites (Like sites that are not verified by LooneySJ.) If you paid for this software, demand for a refund.

Beta Version cannot guarantee a successful result, USE IT AT YOUR OWN RISK.
