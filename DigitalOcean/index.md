# How to make a WEB page (100% free of charge) by Christen Fihl 


Disclamer: Only this https://www.fihl.net/DigitalOcean/ page was original done this way, now I do use [github pages](https://pages.github.com/)


DigitalOcean now has a new feature, App’s, and for this use, static pages on demand. 

This page is written, using Microsoft Word, but anything goes as an editor. 

index.html could be as simple as just containing
Hello World

## How it’s made…

### On github do: 
*	You will need a github.com account, and a repo in there; let’s call it WWW
*	To have a readme and other stuff at hand, I create the real site inside a folder SITE

![SITE](https://www.fihl.net/DigitalOcean/picts/SITE.png)

* Inside SITE you have your read web page, with index.html etc. 

![SITE](https://www.fihl.net/DigitalOcean/picts/SITE2.png)

As of now, I am now editing file git/WWW/SITE/DigitalOcean/index.md, that is, I am using MSCode for the edit, see the raw file **[here](https://www.fihl.net/DigitalOcean/index.md)**
My index.html is created from the md one, by the Markdown All in One plugin (press F1, and type **print**)
* Commit it all to github (index.md not needed, but I just do anyway)

### Now on DigitalOcean do:

* Get yourself a free account, like using my referral link: [DigitalOcean](https://m.do.co/c/a01c93af1655) (you and Christen gets some $$)
* Goto Apps(NEW), and use Create – Apps 

![Create](https://www.fihl.net/DigitalOcean/picts/Create.png)

* In 4 steps you just accept most as default, except tell that site is not in / but in /SITE
* Select repository

![Repo](https://www.fihl.net/DigitalOcean/picts/Repo.png)

* Before that, you need (once only) to say yes to allow DigitalOcean access to your github repo!
* Next!
* If you do see red warning, there is no index.html in the selected repo. Try again..

![noDetect](https://www.fihl.net/DigitalOcean/picts/noDetect.png)

* Then manually type SITE to have /SITE

![selSITE](https://www.fihl.net/DigitalOcean/picts/selSITE.png)

* Do keep the Autodeploy option enabled

![autoDeploy](https://www.fihl.net/DigitalOcean/picts/autoDeploy.png)

* Next!
* Next!
* Next, until deploying, and then your site is online
* Online in some strange url
* Go try it out there
* Mine looks like:

![mine](https://www.fihl.net/DigitalOcean/picts/mine.png)

* And my Live App URL is at [www.fihl.net](https://www.fihl.net/)

### Using your own URL, this is How it’s made…
* Goto your App, and press Settings, and do edit Domains

![apps](https://www.fihl.net/DigitalOcean/picts/apps.png)

![domains](https://www.fihl.net/DigitalOcean/picts/domains.png)

* Select DIY version of DNS (or use DigitalOcean if you like)

![DIY1](https://www.fihl.net/DigitalOcean/picts/DIY1.png)

* Copy the strange URL pressing the Copy button

![DIY2](https://www.fihl.net/DigitalOcean/picts/DIY2.png)

* Goto your DNS account, and add a CNAME for your domain, using the copied alias:

![DIY3](https://www.fihl.net/DigitalOcean/picts/DIY3.png)

## And that is how you can now read this page on address  [https://www.fihl.net/DigitalOcean/](https://www.fihl.net/DigitalOcean/)

The magic is now that whenever you do change your file locally, and push it to github, then the webpage is recreated on the fly, with no downtime, in a minutes time
![magic](https://www.fihl.net/DigitalOcean/picts/magic.png)


## And it is all free of charge, using
* Microsoft Visual Studio Code
* CheatCheet https://www.markdownguide.org/cheat-sheet
* [Markdown All in One by Yu Zhang, for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
* [DigitalOcean free $200 credit](https://m.do.co/c/a01c93af1655)
* [![DigitalOcean](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://m.do.co/c/a01c93af1655)
