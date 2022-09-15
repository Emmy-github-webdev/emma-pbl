# Google App Engine

Google App Engine is used to build and deploy (host) website.

### [Create a Ruby/Node app in the App Engine](https://cloud.google.com/appengine/docs/standard/ruby/create-app)

#### Prerequsites

1. Create google account
2. Create a Google Cloud project in the google clod console
3. Enable the API
4. Install and initialize the google cloud CLI

_Initialize App Engine app with the project name

```
gcloud app create --project=[YOUR_PROJECT_ID]
```
_Deploy App_

```
gcloud app deploy
```
_Launch your browser to view the app_
```
gcloud app browse
```