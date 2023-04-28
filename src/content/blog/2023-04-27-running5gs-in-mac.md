---
author: Viz
pubDatetime: 2023-04-27T21:41:46
title: Do you want to run a 5G network in Apple Silicon 🖥️ ?
featured: true
description: Read this post if you are considering to run a 5G network in your home lab powered by Apple Silicon
draft: false
ogImage: https://unsplash.com/photos/bIgpii04UIg
tags:
  - Telecom
  - 5G-Series
  - experiments
---

So you have got your new Apple Silicon powered machine 🖥️ (Macbook Pro / MacMini / MacStudio ) and you are super eager to bring up a 5GC and gNodeB Simulator. Lets see.. If you want to try open5gs in Mac based ARM systems, you have 2 approaches

1. Install Natively in MacOS
2. Install in a Virtual Machine - Which is what I prefer

Again within Virtualization, Currently there are 2 choices for Linux Virutalization in MacOS

1. Use [UTM](https://getutm.app/) - QEMU based virtualization manager that supports Apple Virtualization Kit for Advanced Usecases
2. Use [Virtuabox Developer preview](https://www.virtualbox.org/wiki/Downloads) - Which is way less performant based on my experience

Obviously. I chose to [UTM](https://getutm.app/). Here again there are multiple choices
	1. Emulate x86 Linux OS within ARM
	2. Virtualize a Linux ARM VM inside Apple Silicon

I tried both approach and here are my observations

1. Emulating x86 inside ARM will make the open5GS and MongoDB installation smoother based on the APT package manager install, but it has very very poor emulation performance
		a. For this to work, you actually need Mongo DB running. But in my case, since UTM QEMU doesn't support `AVX` instruction set emulation, MongoDB didn't start and core dumped with 

```python
ILL (Illegal Instruction Set) Error.
```

2. Next I tried with Linux ARM within Apple Silicon and after lot of trial & errors, this is what worked for me
	1. First, install Ubuntu 22.1 ARM based instance as a VM
	2. Next, install Mongo DB by adding the APT source
		1. Latest Mongo DB will fail with `libssl1.1` dependency and the great gurus of Ubuntu stopped supporting `libssl1.1` and moved to `libssl3` in Ubuntu, where Mongo DB requires `libssl1.1` . This is one of those Face Palm moments 🙈 in Opensource based ecosystems. You don't know when & how the dependencies change and there is absolutely no trace. Here is where RH, Suse & Canonicals of the world will thrive since they do all required heavy lifting for the enterprise & telcos. Okay back to this topic...
		2. Nevertheless some good opensource souls 👼🏻 have provided the arm64 port of `libssl1.1.so` here: [http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb](http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb) .
		3. Install that. Then Mongo DB will install without any errors.
	3. Okay so the next stop is installing **Open5GS** package in Ubuntu. This should be faily simple since **Open5GS** is available as part of standard `apt get` right? Well not easy.. If you try to check [here](https://launchpad.net/~open5gs/+archive/ubuntu/latest/+packages), you will only see `amd64` packages. So this leaves us with the only option of building from source as noted in https://open5gs.org/open5gs/docs/guide/02-building-open5gs-from-sources/. However this step worked like a charm without any hiccups

Now I will go-ahead with UERANSIM on Linux ARM on Apple Silicon. Lets see how this goes. Stay tuned !