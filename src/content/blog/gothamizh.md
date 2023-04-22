---
author: Viz
pubDatetime: 2023-04-22T16:09:36
title: go-தமிழ் 
featured: true
description: Tamil transliteration tool in golang for fun & learning
draft: false
tags:
  - golang
  - programming
---
<img class="rounded-full mx-auto" src="/assets/go_thamizh.png"/>

Having got my feet wet with <i>golang </i> by implementing <a href="http://kspviswa.github.io/starting-out-as-a-gopher.html"> <code> ls </code> equivalent command </a> in <code> golang </code>, It's now time to explore some depths.

In this post, I'm gonna talk about my new project,
 <b> <a href="https://github.com/kspviswa/gothamizh"> go-தமிழ் - Tamil transliteration tool in golang for fun & learning </a> </b>. 
<hr>

<big> தமிழ் </big> (Thamizh not Tamil) is my mother tongue. It is absolutely fantastic to see thamizh letters in internet. Due to recent developments in typographic / indic technologies, it is now very easy to type & view in native languages.

At a very basic level, native languages are represented as **Unicode, UTF-8, UTF-16, UTF-32** special characters. This way, computers can make sense of every char of every possible language as just an integer. 

Although handling <b>UTF-8</b> strings is defnitely a pain, `golang` seems to support this out of the box. Especially their [ `unicode/utf8` package ](https://golang.org/pkg/unicode/utf8/) is worth a read.

Having known that `golang` can support தமிழ் natively & having learnt the basics of `golang`, why not develop a english -> தமிழ் transileration tool ??

## Basics of `go-தமிழ்`

`தமிழ்` can be largely categorized as உயிர் ( Primary), மெய் (Secondary) & உயிர்மெய் (Vowels). 

For example `தமிழ்` letter `க` is derived from `க்` ( which is `மெய்`) and `அ` ( which is `உயிர்`). <br> i.e `க் + அ = க`. Similalry `மி = ம் + இ`.

However in unicode world, the vowels appear as special character. They appear in  ், ா, ி form only. So in unicode world, inorder to get `மி`, we should concatinate `ம` & `  ி ` i.e `மி = ம +  ி `.

So it turns out that, generating tamil characters is quite challenging & interesting. Upon receiving a english transileration text say `vanakkam`, we need first find the pattern of difference between printing a `உயிர்` & `உயிர்மெய்`. 

For instance, `vaa` can be interpreted as `வஅ` or `வா`. So it is quite clear that, we need a mechanism to identify whether the user wants to pronounce vowel sounds, or they want to get the actual letter here. In-order to solve this problem, I resorted to have my own encoding scheme for `go-தமிழ்`.

## Architecture of `go-தமிழ்`

Having decided that, I need to come up with my own encoding rules ( heck this is my own new encoding tool for fun! ), I then started to lay out basic grammer for my own `tanglish` language.

You can take look at the grammar for  `go-தமிழ்` in the `help` page of the webpage that gets served as part of `go-தமிழ்` daemon mode.

To give you some glimpse...

<table style="width:30%">
                    <caption>உயிர் | Primary </caption>
                    <tr>
                        <th>தமிழ்</th><th>English</th>
                    </tr>
                    <tr>
                        <td>அ</td><td>a</td>
                    </tr>
                    <tr>
                        <td>ஆ</td><td>2a</td>
                    </tr>
                    <tr>
                        <td>இ</td><td>i</td>
                    </tr>
                    <tr>
                        <td>ஈ</td><td>2i</td>
                    </tr>
                    <tr>
                        <td>உ</td><td>u</td>
                    </tr>
                    <tr>
                        <td>ஊ</td><td>2u</td>
                    </tr>
                    <tr>
                        <td>எ</td><td>e</td>
                    </tr>
                    <tr>
                        <td>ஏ</td><td>2e</td>
                    </tr>
                    <tr>
                        <td>ஐ</td><td>3i</td>
                    </tr>
                    <tr>
                        <td>ஒ</td><td>o</td>
                    </tr>
                    <tr>
                        <td>ஓ</td><td>2o</td>
                    </tr>
                </table>

For complete details on `go-தமிழ்` encoding rules, please [this page](https://github.com/kspviswa/gothamizh/blob/master/help.html).

### Algo

* Get the input text and split it based on space delimiter, resulting in `slice` of input tokens.
* Now iterate over each token and perceive every letter of input token as in-turn a `slice`.
* By using [Golang slicing of the slice ](https://blog.golang.org/go-slices-usage-and-internals) technique, iterate from `0` to `len(token)`.
    - Match the new slice with either uyir, mei or vowels pattern.
    - If found, then increment both start & end indices.
    - If not, then increment only end and re-slice the slice from `start:end` pattern.
    - Loop & repeat till exit.

### Deployment

After the main logic got working, now it is just a matter of how to present & package the tool. Usablity is the key aspect here.

Next, inorder to spice up the meal, I decided to have 2 modes of operation - *Console* mode & *Daemon* mode.

**Console** mode will mimic a `go-தமிழ் >>` shell, which takes in english input and return `தமிழ்` text in the terminal out ( if terminal support is there for UTF-8).

![console](/assets/go-thamizh-console.png)

**Daemon** mode will run a webserver at port 8080 and it will serve **transliteration as a service** . For this, I shamelessly copied [Golang playground CSS](https://play.golang.org/) and re-used to my theme. I have to say, it perfectly fitted to my design and I'm kinda proud of it :-)

![webpage](/assets/go-thamizh-webpage.png)