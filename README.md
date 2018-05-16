## Development Mail Server

The purpose of this image to to emulate a Postfix/mail server but never actually send any mail out to the world. This is useful when developing web applications which are expected to send mail but you don't want them to accidentally mail read users or you wish to inspect the mail that the application would normally send out.

The image comes with a built in Roundcube install running on port 80 which collects the outbound mail. Mail is cleaned up after 24 hours.

## TODO

* Add imaputils.pl to delete old messages
* Auto redirect to /?_autologon=true in roundcube

imaputils.pl --host localhost --user catchall --password password --box INBOX --delete --sentbefore $(($(date +%s)-86400))
