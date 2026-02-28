x86 Hax

What is this?

I have an x86 Samsung tablet (CloverView+) and my dream is to somehow run cool stuff like EDK II or SeaBIOS on it. But in order to do that, I have to set the basics first.
This is basically my bridge to boot a raw binary to the tablet. It's not much. But I want to make this payload load raw executables like the ones mentioned earlier.


Why would you do that?

Because the Intel SFI specification is at the edge of being deprecated. Any time now, somebody could just nuke the existing SFI support code out of mainline. By bringing a PC standard to machines like this
I can p much extend and improve Linux support on such tablets. Because I highly doubt Linux is going to completely nuke 32 bit x86 support any time soon.


How do I try it?

Method 1, kexec (requires root):

	Get a statically linked 32 bit x86 version of kexec tools (best verion is 2.0.6)
	Compile the payload
	adb shell su
	go to your kexec executable's location
	"./kexec -l ${PATH_TO_YOUR_PAYLOAD_FILE} --mem-min=0x10000000 --mem-max=0x36feffff"
	"./kexec -e"
	...enjoy your tablet being frozen for a solid minute
	watchdog resets the tablet


How can I help?

If you know how to work with x86 assembly or have any info on how SFI tables work, contact me at
	incogninto123${AT}gmail${DOT}com
	or as a backup
	incogninto123${AT}icloud${DOT}com

Thank you for checking out this repo :D
