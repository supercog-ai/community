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

Edit `env.base` to set your `OPENAI_API_KEY`.

Run setup:

    ./setup.sh

Run from Docker:

    docker compose up

And now open the Dashboard:

http://localhost:3000/register/

Now create an account with an email address to get started.

## Using Supercog

When you first login you will see a set of example agents that you can
try out. Just click on the agent and start typing into the Prompt box. You
can try adjusting the _Agent Instructions_ to see how you can change the
agent's behavior.

Now try opening the special _Supercog_ agent. This pre-built agent has
instructions for dynamically adding and working with tools. Try a conversation
like this:

```text
    you) What tools are available?_

    Here are the tools that are available for use:

    Admin
    REST API (Authorized)
    Send Email (built-in)
    ...

    you) Let's add the Github tool
    ...
      enabling the Github tool
    ...
```

when you add the Github tool, you will be prompted to enter an access token. You
can make one from Github->Settings (look for _Developer Settings_). Once you have
connected Github then you can access your repos, issues, etc...

Here are some other things to try with tools:

- Try adding the Image Recognition tool (just type "add image recognition") then upload an image and ask Supercog
to explain what's in it.

- Try using "text to speech" to create audio output. We use this in the "Morning News Reporter" demo agent.

- Use the Database tool to connect to a database you have any, then try _text to SQL_ by
asking questions about your data in plain English. Bonus points: add the Charting tool
and try creating charts from your data.


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
