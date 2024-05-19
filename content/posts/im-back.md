---
title: "I am back... again!"
date: 2020-09-15T11:30:03+00:00
# weight: 1
# aliases: ["/first"]
tags: ["first"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Desc Text."
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
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

## Where have I been?

In the previous iteration of this website (there have been many iterations before it). I was running [chunwu.dev](https://chunwu.dev) using [Hugo](https://gohugo.io). The site was hosted in Azure Storage and leveraged Azure's Content Delivery Network. 

My hope was that by having a web presence, it would force me to blog about all the various things I am working on - as they say, you don't understand a topic until you can teach it. With the goal that I would share some knowledge and inspire the next person, as many have done for me. The Problem... blogging requires time and commitment. 

In the last 4 years, I have:
- made a huge pivot in my career. 
- moved to another country.
- got married.
- And most recently, my wife and I welcomed our son - Aiden.

### What am I trying to achieve?

My personal goal is to have a miniaturized version of the PaaS (Platform as a Service) environment that I am developing at scale for work. Whenever you work on projects that have the scale that I typically work at, we do not typically get the opportunity to work on all aspects of the platform - as there is just too much to do. Building my homelab would help me understand various technologies in detail and if something breaks, I will at least have an idea how to triage. 

### What have I done so far? 

Up to this point, I am running a [Kubernetes](https://kubernetes.io/) cluster using 4 Raspberry Pi 4B 8GB. It is configured using one node as the Control Plane and 3 nodes for the data plane. I have a few stateless applications running that have been exposed to the internet using Cloudflare's Zero Trust tunnel, and a monitoring stack using Prometheus, Grafana and Alert Manager.

If this all sounds interesting to you, great! The existing infrastructure is a bit janky and is a major motivation for today's post. 

### What is next?

Initially when I completed custom writing a blogging solution using Python and the Flask framework to kick things off, I encountered my first hurdle. Every time I made a breaking change to my homelab the data would be wiped. 

So, as a temporary solution until my homelab stabilizes, I will be using Hugo once again which I will host using Github Pages made available from my custom DNS.

Stay tuned for weekly posts!

-Chun

