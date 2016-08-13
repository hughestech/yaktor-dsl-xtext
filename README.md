[![Yakor Logo](yaktor.io/pics/yaktor-logo.png)](https://github.com/Scispike/yaktor) 

Yaktor DSLs created by SciSpike creating data models and behavior for your Yaktor Application

[![Travis status](https://img.shields.io/travis/SciSpike/yaktor-dsl-xtext/master.svg?maxAge=3600)](https://travis-ci.org/SciSpike/yaktor-dsl-xtext/builds)
[![Coveralls status](https://img.shields.io/coveralls/SciSpike/yaktor-dsl-xtext/master.svg?maxAge=3600)](https://coveralls.io/github/SciSpike/yaktor-dsl-xtext?branch=master)
[![Maven Central](https://img.shields.io/maven-central/v/io.yaktor/xtext-dsl-cli.svg?maxAge=3600)](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22io.yaktor%22%20AND%20a%3A%22xtext-dsl-cli%22)
[![license](https://img.shields.io/github/license/SciSpike/yaktor-dsl-xtext.svg?maxAge=3600)](https://github.com/SciSpike/yaktor-dsl-xtext/blob/master/LICENSE)
[![Gitter](https://img.shields.io/gitter/room/SciSpike/yaktor.svg?maxAge=3600)](https://gitter.im/SciSpike/yaktor)
[![npm](https://img.shields.io/npm/v/yaktor-lang.svg?maxAge=3600)](https://www.npmjs.com/package/yaktor-lang)

## Introduction

This is an Xtext-based project containing the Yaktor DSLs created by SciSpike, which includes
* the Yaktor DSL eclipse jars,
* the Yaktor DSL command line interface (CLI),
* the Yaktor DSL eclipse Plugin, and
* the `yaktor-lang` npm module.

## Building

Prerequisites:

* `docker build -t yaktor-mvn-build docker`

```
./build.sh mvn clean install
```

FTW

```
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

Or, to build from your unsupported native environment:

* Maven 3.2 (*exactly* 3.2, for now)
* JDK 7 (JDK 8 has not yet been tested)
* Node 4.4.x & its associated `npm`
* A recent version of `git`
* A Unix-like build environment

```
MAVEN_OPTS='-Xms256m -XX:MaxPermSize=1024m -Xmx1024m' \
  mvn clean install -V
```

Oh, so sorry you have errors.

```
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[ERROR] Your Environment is to blame
```

## Releasing the Yaktor DSL CLI

> NOTE: this creates a new release that's published to the world.

### What Kind of Release?
We follow [semver](https://www.semver.org) release semantics.  Refer to them when deciding on which kind of release to perform.

There are three kinds of releases: minor, patch & prerelease.

> NOTE: major releases are no different than minor releases; the only difference is that
you're minor & patch versions are `0` (the full version is `n.0.0`, where `n` is an integer).  In order to prepare for a major release, you must
update the versions to `x.0.0-SNAPSHOT`, where `x` is the next major version.  You can do that with `./bump.sh premajor`.
Then, you perform a minor release as described below.

#### Major or Minor Release

In order to perform a major or minor release (`z.0.0` or `x.y.0`, respectively), do the following.
* Get the Yaktor source to your machine & note its absolute path; see section "Building" above.
* `git checkout master`
* `grunt release-minor`

Grunt task `release-minor`
* builds & tests the multimodule Maven project,
* creates a maintenance branch,
* bumps all versions appropriately in `master` & the maintenance branches,
* creates all appropriate release tags,
* pushes everything to GitHub (which triggers a [Travis CI build](https://travis-ci.org/SciSpike/yaktor-dsl-xtext/builds)),
* publishes the Yaktor DSL CLI Java artifact to Maven Central, and
* publishes the Yaktor DSL npm module to npmjs.com.

#### Patch Release

In order to perform a patch release (x.y.z), do the following.
* Get the Yaktor source to your machine & note its absolute path; see section "Building" above.
* `git checkout` the maintenance branch.  Maintenance branches take the form `vi.j.x`, where `i` & `j` are integers, like `v1.2.x`.
* `grunt release-patch`

Grunt task `release-patch`
* builds & tests the multimodule Maven project,
* bumps all versions appropriately,
* creates all appropriate release tags in the maintenance branch,
* pushes everything to GitHub (which triggers a [Travis CI build](https://travis-ci.org/SciSpike/yaktor-dsl-xtext/builds)),
* publishes the Yaktor DSL CLI Java artifact to Maven Central, and
* publishes the Yaktor DSL npm module to npmjs.com.

#### Prerelease

Prereleases (or `SNAPSHOT`s, in Maven parlance) are automatically performed on pushes to the `master` branch or any maintenance branch (`vi.j.x`).
Builds are on [Travis CI](https://travis-ci.org/SciSpike/yaktor-dsl-xtext/builds).
If you need to publish a prerelease of the CLI npm module, you must do so **manually** after your *successful local build* by doing the following:
* `cd ./cli/target/npm`
* `npm login ...` (optional)
* `./npm-publish.sh`

## Releasing the Yaktor Eclipse Plugin to Our Eclipse Update Site

> NOTE: automating this is a [TODO](https://github.com/SciSpike/yaktor-dsl-xtext/issues/5)

> NOTE: this requires [Amazon's `aws` CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html#install-bundle-other-os); `brew install awscli` or `apt-get install awscli` works.
Make sure that you have credentials in `~/.aws/credentials` like:
```
[scispike]
aws_access_key_id = xxxxxxxxxxxxxx
aws_secret_access_key = yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
```

To upload a new version of the Yaktor DSL Eclipse Plugin and make it available at our Eclipse update site, http://yaktor.io/eclipse:
```
npm install
composite/site.js --sites 0.2.0,1.0.0 # include all sites you wish to make available
composite/upload.sh
```
