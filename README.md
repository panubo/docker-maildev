## Development Mail Server

The purpose of this image to to emulate a Postfix/mail server but never actually send any mail out to the world. This is useful when developing web applications which are expected to send mail but you don't want them to accidentally mail real users or if you wish to inspect the mail that the application would normally send out.

The image comes with Roundcube installed and running on port 80 which collects the outbound mail. Mail is cleaned up after 24 hours.

## Authentication

There is no authentication required for all services.
