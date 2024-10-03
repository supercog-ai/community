# Supercog Developer Edition

<img width="1103" alt="Screenshot 2024-10-02 at 4 17 00 PM" src="https://github.com/user-attachments/assets/98377aea-f2a0-4a52-81fe-be3878c80562">


This repo will help you get setup to run the Supercog system on your local
machine. This is especially useful if you need to:

- Develop new agent tools
- Run tools which require localhost access
- Want to run agents locally with full data controls

## Requirements

You will need these core pieces:

1. Docker
2. OpenAI [API key](https://openai.com/index/openai-api/)

Optional:

3. Google Oauth client to enable Google Auth
4. AWS configuration for Simple Mail Service. Provide keys that are enabled for SES
if you want to use the built in "Send Email" tool.

## Installation

First, copy `env.example` to `env.base`.

Edit `env.base` to add your `OPENAI_API_KEY`, and optionally add your `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`.

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
the directory `./supercog/tools`. The `DummyTool` example tool,
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

- [Tavily](https://tavily.com/#api) search tool
- [ScaleSERP](https://app.scaleserp.com/) Web Search
- [Zyte](https://docs.zyte.com/zyte-api/get-started.html) Web screenshots

Most of these services have a free tier you can get started with.

## Accessing uploaded files
We use MinIO to store any files you upload locally. (See their
[Github](https://github.com/minio/minio) and
[Docker Hub](https://hub.docker.com/r/minio/minio)).
These files will persist in the docker volumne `supercog-dev_minio-data`.
To view the files and images in MinIO, use their console by going to:

    http://localhost:9003

All images will be stored in the `images-bucket` and all other
files will be stored in the `files-bucket`.
