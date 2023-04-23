---
author: Viz
pubDatetime: 2023-04-22T19:34:30
title: Trust but Verify
featured: false
description: As a developer do you trust your code?
draft: false
tags:
  - musings
  - programming
  - career
---

## Table of Contents

## What is Trust ?

**Trust**, very powerful word in English. Trust gives us hope, hope gives us life and make us live.

Trust is all we do either voluntarily / involuntarily. We trust our parents, our friends, our government ( election is around the corner 😛 ). We even trust some people blindly like bus drivers, manufacturing industries etc. We even trust google / microsoft / amazon / apple and let our private data sit in their servers. Isn’t it?

Countries trust each other, humans trusts gods, lungs trust our atmosphere, we trust that there will be tomorrow.

Trust fills every ounce of this universe. Yet, there is uncertainty, absurdity, fear of aliens, fear of attacks, fear of data theft, fear of data piracy, fear of corruption, possibility of anything to become nothing and nothing to become anything.

In software industry, particularly in engineering support kind of projects, we deal with lot of ambiguity & absurdity. Same code, same platform, same set of inputs, will work in one machine, but it won’t on some other machine. To fuel more of this absurdity, the possibility of code, not working, seems to be higher in customer / end user environment, not on the developer’s or tester’s. I was into one such absurd situation earlier.

![6d63bd23ad5e60f5a9ccbc60ed2a25a7](https://kspviswa.files.wordpress.com/2016/03/6d63bd23ad5e60f5a9ccbc60ed2a25a7.jpg?w=529)


## The Plot

There was a field issue, pretty much escalated as a steam-engine. The ticket description, also claimed that, until they upgrade to recent patch that we delivered 2 days earlier, there was no issue. When I reviewed the commit history, there was no other commits visible. i.e Other than the recent bug fix, that we made, there was no code change, which could account for this absurd behaviour.

I was even sceptical, whether customer had “really” seen this behaviour or not 🙂 . I blindly trusted the CM tool and I argued that, if there is no commit history about any recent code change, then for sure, there is no mistake on our part. Computers don’t lie.. do they 😛 ( unless you told them to do so 😛 ).

I didn’t give up and started the `ping-pong` war with support folks. I was very adamant and  argued that, unless I “see” the problem, I’m not gonna believe it. Here, you need to understand the scenario. I work for company X, for client Y, and there is the customer Z for Y. So in Z’s conference, I represent Y’s engineering team. Since I was not ready to believe customer’s issue, after a long persuasion, end customer finally agreed for a remote session.

I was pushed into a real situation now. My manager (X) warned me that, if I confirm the issue, then the real problem is, we have to face the heat of the end customer (Z) + actual customer (Y). Now the problem has actually transformed from a regression issue to ego issue. You will be amazed to realize, how things actually change to anything from nothing.

I was now in a very confused state. To proceed with the remote session ( as I trust the CM tool ) or abort it and re-work on my analysis again ( as I have to trust the customer eventually ).

## Trust but Verify

Thankfully, I had a good manager / mentor ( Y ). He was involved in the discussion from the start, and also kind of acknowledged my push for remote session ( however not supported it out rightly ). I invited him for a short talk and explained my problem. He just uttered the golden words..

> “Trust… but Verify…”

This sentence, kept ringing me throughout the day. I had just 6 hrs to confirm my availability for the remote session. I had to make a decision. But.. Trust.. but verify… Trust but verify… Trust.. but verify… kept haunting my mind.

I decided to give it a try, keeping aside my ego, my 6th sense. I started to analyse the entire problem with clear state of mind, without any prejudice. So going back to basics, if there is any change in the content of the file, it would result in the md5 hash of the executable that is being produced. That being said, the hash of the executable file, which is used by customer in his set-up, has to be equal to the one that is shipped from our side. I quickly collected the executable hash from my development machine ( the exact version that used by customer) and pinged my good friend in support team, to quickly extract the hash info from the case-notes without much noise :P.

This gave the first clue. Both hash didn’t match. So clearly, customer was not using the same version of executable, that he was supposed to be using. So this looks like a clear miscommunication issue. Again… the bell rang… Trust.. but Verify… Trust… but Verify..

Ok, now Customer is using something, that was provided to him by support folks. Clearly this doesn’t align with what was built from development. This looks like a classic client server problem right..? Clients sends a request over unreliable channel ( UDP for instance ) and wait from Server to respond. When the response didn’t arrive, what are the possibilities. The packet from client, didn’t reach the server itself OR Server had processed the packet and sent the response, however it didn’t reach the client OR Server is so busy with processing the packet. It is not possible for the client to get the exact error reason. All it can assume is that, there  might be some problem with the server, so let me retry sending the packet again. Coming back to the situation in hand, there are possibilities that, development team had themselves provided the faulty version of the binary ( which in theory not possible, since the commit history is clean ).


Luckily, there is a policy of maintaining last build’s artefacts, until either a new build is scheduled or there is no space. I quickly retrieved the build log and extracted the hash of the executable. To my utter surprise, rather shock ( as I started to believe in customer now :P) the hash is same as the one used by customer. So it is quite clear that, the last build has some-how messed up with build generation.

Again, still the situation hasn’t stripped it’s absurdity. If the build script is change any code, it has to enter a commit log. It it has to enter a commit log, then it should show in the commit history. The dots aren’t still connected. But atleast there is some light now. There is a problem at my end. It is now crystal clear. It is now only minutes away from its final revelation. The hunt is ON. This provided me some confidence to move on.

Suddenly I felt really intrigued on the problem. My ego on  my belief, the fear of being confronted with end customer when he learns that, what he had claimed was actually true etc everything evaporated. To me, it looks like solving a case 😛 .

Then I carefully read through the entire build log ( ~ 3 GB text file ), line by line, target by target. The entire experience was very thrilling. Every time, when I cross the target’s log and find that everything was normal, there is a mixed feeling. If everything is al right, then my initial belief was right, but then the absurdity is still real 🙂 . If I find a problem, I might understand what had went wrong, but again, I will face the heat from lot of people 🙂 .

## Smoking gun

About after 2 hours of analysis, I found the root-cause. There goes an ancient quote, Well began is half done. In software engineering support world, we go by this quote,

> “Root-Caused problem is almost resolved”

The real problem was this. During the build time (i.e the code freeze was done and the build script was now working to “cook-out” the final build ), another developer had actually checked-in a fix ( which is on the same lines of the problem that the customer had ) and had also activated a “merge” task to merge the new fix into the release, at a later point of time. However due to syntax error in the commit template, merge got scheduled to current release itself. To add more fuel, the build script had actually tried to issue a commit to central repo ( so as to be shown in commit history ), however that commit got failed since, we had freezed write permission to the repo. The code has been committed locally, but not to server. This error as classified as soft error and the build proceeded without triggering any alarms.

## On a hindsight

Huhhhh. What a costly learning 🙂 . I don’t wanna bore you more by explaining how we faced the heat, tackled the customer, gained back the confidence etc. That is a special story 😛 .

So remember… _**Trust…!!! but Verify…!!!**_. 🙂