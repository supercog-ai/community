# Running Supercog locally

This repo will help you get setup to run the Supercog system on your local
machine. This is especially useful if you need to:

- Develop new agent tools
- Run tools which require localhost access
- Want to run agents locally with full data controls

## Requirements

You will need these core pieces:

1. Docker
2. OpenAI [API key](https://openai.com/index/openai-api/)
3. AWS access keys for S3, and 2 S3 buckets, for storing files

Optional:

4. Google Oauth client to enable Google Auth
5. AWS configuration for Simple Mail Service. Provide keys that are enabled for SES
if you want to use the built in "Send Email" tool.

## Installation

First, create two buckets in S3 to store application files. One bucket should be
public readable, for storing generated and sharable image files. The other bucket
should be private for storing data.

Now copy `env.example` to `env.base`.

Edit `env.base` to add your config keys. Set the S3 buckets like:

    S3_PUBLIC_BUCKET - name of the public readable bucket
    S3_FILES_BUCKET_NAME - private bucket for all other files

Run setup:

    ./setup.sh

Run from Docker:

    docker compose up

And now open the Dashboard:

http://localhost:3000

Unless you created your own Google OAuth client, you will have to register with an
email address, but verification will be skipped by default.

## Creating new tools

To create new tools, just add tool class definitions in Python into
the directory `$HOME/supercog/tools`. The `DummyTool` example tool,
which provides a single `calc_fibonacci` function, is placed there
as an example.

Checkout the `Tool Builder Agent` default agent which appears on the home page
when you login.

## Using LLMs besides those from OpenAI

## Using non-free service tools

A number of standard tools require API keys in order to operate. You will need to
register with the indicated service to get the API key, then set an Env Variable
on the `Settings` page to store the value.

Examples of tools which require an API key include:

- Tavily search tool
- SERP Scale Web Search
- Zyte Web screenshots
