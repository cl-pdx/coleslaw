# General Use

* Add a list with the plugin name and settings to the ```:plugins```
  section of your [.coleslawrc][config_file]. Plugin settings are described below.

* Available plugins are listed below with usage descriptions and config examples.

## Analytics via Google

**Description**: Provides traffic analysis through [Google Analytics](http://www.google.com/analytics/).

**Example**: `(analytics :tracking-code "google-provided-unique-id")`

## Comments via Disqus

**Description**: Provides comment support through [Disqus](http://www.disqus.com/).

**Example**: `(disqus :shortname "disqus-provided-unique-id")`

## Hosting via Github Pages

**Description**: Allows hosting with CNAMEs via [github-pages](http://pages.github.com/). Parses the host from the `:domain` section of your config by default. Pass in a string to override.

**Example**: `(gh-pages :cname t)`

## LaTeX via Mathjax

**Description**: Provides LaTeX support through [Mathjax](http://www.mathjax.org/) for posts tagged with "math" and indexes containing such posts. Any text enclosed in $$ will be rendered, for example, ```$$ \lambda \scriptstyle{f}. (\lambda x. (\scriptstyle{f} (x x)) \lambda x. (\scriptstyle{f} (x x))) $$```.

**Example**: ```(mathjax)```

**Options**:

- `:force`, when non-nil, will force the inclusion of MathJax on all posts.  Default value is `nil`.

- `:location` specifies the location of the `MathJax.js` file.  The default value is `"http://cdn.mathjax.org/mathjax/latest/MathJax.js"`.  This is useful if you have a local copy of MathJax and want to use that version.

- `:preset` allows the specification of the config parameter of `MathJax.js`.  The default value is `"TeX-AMS-MML_HTMLorMML"`.

- `:config` is used as supplementary inline configuration to the `MathJax.Hub.Config ({ ... });`. It is unused by default.

## ReStructuredText

**Description**: Some people really like [ReStructuredText](http://docutils.sourceforge.net/rst.html). Who knows why? But it only took one method to add, so yeah! Just create a post with `format: rst` and the plugin will do the rest.

**Example**: `(rst)`

## S3 Hosting

**Description**: Allows hosting your blog entirely via [Amazon S3](http://aws.amazon.com/s3/). It is suggested you closely follow the relevant [AWS guide](http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html) to get the DNS setup correctly. Your `:auth-file` should match that described in the [ZS3 docs](http://www.xach.com/lisp/zs3/#file-credentials).

**Example**: `(s3 :auth-file "/home/redline/.aws_creds" :bucket "blog.redlinernotes.com")`

## Sitemap generator

**Description**: This plugin generates a sitemap.xml under the page root, which is useful if you want google to crawl your site.

**Example**: `(sitemap)`

## Static Pages

**Description**: This plugin allows you to add `.page` files to your repo, that will be rendered to static pages at a designated URL.

**Example**: `(static-pages)`

## Wordpress Importer

**NOTE**: This plugin really should be rewritten to act as a standalone script. It is designed for one time use and using it through a site config is pretty silly.

**Description**: Import blog posts from Wordpress using their export tool. Blog entries will be read from the XML and converted into .post files. Afterwards the XML file will be deleted to prevent reimporting. Optionally an `:output` argument may be supplied to the plugin. If provided, it should be a directory in which to store the .post files. Otherwise, the value of `:repo` in your .coleslawrc will be used.

**Example**: `(import :filepath "/home/redline/redlinernotes-export.timestamp.xml" :output "/home/redlinernotes/blog/")`

[config_file]: http://github.com/redline6561/coleslaw/blob/master/examples/single-site.coleslawrc

## Twitter

**Description**: This plugin tweets every time a new post is added to your repo. See Setup for an example of how to get your access token & secret.

**Example**: `(twitter :api-key "<api-key>" :api-secret "<api-seret" :access-token "<access-token>" :access-secret "<access-secret>")`

**Setup**:
- Create a new [twitter app](https://apps.twitter.com/). Take note of the api key & secret.

- In the repl do the following:
```lisp
;; Load Chirp
(ql:quickload :chirp)

;; Use the api key & secret to get a URL where a pin code will be handled to you.
(chirp:initiate-authentication
 :api-key "D1pMCK17gI10bQ6orBPS0w"
 :api-secret "BfkvKNRRMoBPkEtDYAAOPW4s2G9U8Z7u3KAf0dBUA")
;; => "https://api.twitter.com/oauth/authorize?oauth_token=cJIw9MJM5HEtQqZKahkj1cPn3m3kMb0BYEp6qhaRxfk"

;; Exchange the pin code for an access token and and access secret. Take note
;; of them.
CL-USER> (chirp:complete-authentication "4173325")
;; => "18403733-bXtuum6qbab1O23ltUcwIk2w9NS3RusUFiuum4D3w"
;;    "zDFsFSaLerRz9PEXqhfB0h0FNfUIDgbEe59NIHpRWQbWk"

;; Finally verify the credentials 
(chirp:account/verify-credentials)
#<CHIRP-OBJECTS:USER PuercoPop #18405433>
```
