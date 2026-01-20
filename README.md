# Development Mail Server

A Docker image that runs a complete mail server stack, perfect for development and testing. It's designed to be a catch-all server that receives emails for any address and displays them in a web interface. It **does not** send any mail out to the internet.

This image includes:

- Postfix as a mail transfer agent (MTA).
- Dovecot for IMAP and POP3 access.
- Apache with PHP to serve the webmail client.
- Roundcube as a webmail client to view emails.
- A cron job that cleans up emails older than 24 hours.

<!-- BEGIN_TOP_PANUBO -->
> [!IMPORTANT]
> **Maintained by Panubo** — Cloud Native & SRE Consultants in Sydney.
> [Work with us →](https://panubo.com.au)
<!-- END_TOP_PANUBO -->

## Features

- Catch-all email server for any domain.
- Web-based email access with Roundcube.
- IMAP and POP3 access to emails.
- Automatic cleanup of old emails.
- Configurable via environment variables.

## Getting Started

This guide provides instructions on how to build and run the Docker image using either the provided `Makefile` or standard `docker` commands.

### Using Makefile

The `Makefile` provides convenience targets for common operations.

1.  **Build the image:**
    ```sh
    make build
    ```

2.  **Run the container:**
    To run the container for development or testing, which exposes the web interface on port `8080`:
    ```sh
    make run
    ```
    This command will attach to the container's output. You can detach with `Ctrl+C`.

## Accessing Emails

### Web Interface
The captured emails are available through the Roundcube web interface. If you followed the "Getting Started" example, it will be available at [http://localhost:8080](http://localhost:8080).

The interface uses an autologin plugin, so no username or password is required.

### SMTP, IMAP & POP3

To configure your application, use `localhost` (or your Docker host IP) as the server and the ports you exposed.

- **SMTP server**: `localhost` on port `1025` (no authentication required).
- **IMAP server**: `localhost` on port `1143` (user: `catchall`).
- **POP3 server**: `localhost` on port `1110` (user: `catchall`).

## Configuration

### Main Environment Variables

| Variable    | Description                                                                                                   | Default                   |
|-------------|---------------------------------------------------------------------------------------------------------------|---------------------------|
| `MAILNAME`  | The mail domain for the server. This is used by Postfix in its configuration.                                 | `maildev.example.com`     |
| `SIZELIMIT` | The maximum size of an email in bytes.                                                                        | `20480000` (20MB)         |
| `POSTCONF`  | A space-separated list of Postfix configuration directives. For example `disable_dns_lookups=yes`.            | `(empty)`                 |

See [panubo/docker-postfix](https://github.com/panubo/docker-postfix?tab=readme-ov-file#environment-variables) for more configuration options.

### Volumes

| Path         | Description                                     |
|--------------|-------------------------------------------------|
| `/var/mail`  | The directory where emails are stored.          |

## Ports

| Port  | Protocol | Description        |
|-------|----------|--------------------|
| 25    | SMTP     | Mail submission    |
| 80    | HTTP     | Roundcube webmail  |
| 110   | POP3     | Email access       |
| 143   | IMAP     | Email access       |

## Development

The `Makefile` contains several targets for common development tasks.

- `make build`: Build the Docker image.
- `make run`: Run the container for testing the web interface.
- `make bash`: Get a bash shell inside a running container.
- `make clean`: Remove the built image.

See the `Makefile` for more details and other available targets.

## Releases

Please use a versioned release rather than the floating 'latest' tag.

See the releases for tag usage and release notes.

## Status

Development ready and stable.

<!-- BEGIN_BOTTOM_PANUBO -->
> [!IMPORTANT]
> ## About Panubo
>
> This project is maintained by Panubo, a technology consultancy based in Sydney, Australia. We build reliable, scalable systems and help teams master the cloud-native ecosystem.
>
> We are available for hire to help with:
>
> * SRE & Operations: Improving system reliability and incident response.
> * Platform Engineering: Building internal developer platforms that scale.
> * Kubernetes: Cluster design, security auditing, and migrations.
> * DevOps: Streamlining CI/CD pipelines and developer experience.
> * [See our other services](https://panubo.com.au/services)
>
> Need a hand with your infrastructure? [Let’s have a chat](https://panubo.com.au/contact) or email us at team@panubo.com.
<!-- END_BOTTOM_PANUBO -->
