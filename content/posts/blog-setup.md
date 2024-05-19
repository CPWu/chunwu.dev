---
title: "Custom Domain on Github Pages with Cloudflare"
date: 2024-05-19T01:30:03+00:00
# weight: 1
# aliases: ["/first"]
tags: ["cloudflare","github","dns"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: true
hidemeta: false
comments: false
description: "Keeping it simple"
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "images/cloudflare.png" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

## Introduction

As I had mentioned in a previous post, my desire is to eventually host everything on my own infrastructure and if time permits try to use a DIY solution. However, given that I want to start sharing my journey from day 0, I need a `temporary` solution that is reliable, quick to setup, with minimal effort. Today, I would like to share how I setup this blog using a static website generator [Hugo](https://gohugo.io/) hosted on [Github Pages](https://pages.github.com/) with a Custom DNS using [Cloudflare](https://www.cloudflare.com/). 

