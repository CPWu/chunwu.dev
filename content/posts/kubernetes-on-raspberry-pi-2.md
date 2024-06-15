---
title: "Kubernetes on Raspberry Pi - Part 2"
date: 2024-06-08T09:30:03+00:00
# weight: 1
# aliases: ["/first"]
tags: ["kubernetes", "homelab", "raspberrypi", "k3s", "ansibible"]
categories: ["homelab", "kubernetes", "raspberrypi", "automation"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: false
TocOpen: false
draft: true
hidemeta: false
comments: true
description: "Multi-part series on working with Kubernetes"
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: false
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
    hidden: false # only hide on current single page
    hiddenInList: false
    hiddenInSingle: false
    linkFullImages: true
---

## Ansible

As I am aware that this will not be the last time I will rebuild this cluster (I plan setup HA on the controlplane at a later time)I need a way to automate and simplify the cluster rebuild process each time. Enter Ansible. Ansible is an open-source automation tool that simplifies complex IT tasks. Written in Python, it allows you to automate various operations, such as system configuration, software deployment, and workflow orchestration. Ansible’s strengths lie in its simplicity and ease of use, making it a popular choice for managing infrastructure and achieving operational excellence across different platforms

### Installing Ansible