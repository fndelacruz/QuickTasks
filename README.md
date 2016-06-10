# QuickTasks

[Live on AWS EC2!][live]

## Summary

QuickTasks is a demonstration checklist application written on top of a
custom-built MVC framework modeled after Rails. I made this framework to
have a stronger understanding of what goes on under the Rails hood. The
framework consists of two major components: ActiveRecordLite and RailsLite.

Inspired by ActiveRecord, ActiveRecordLite is an ORM featuring core CRUD
functionality and support for model relationships such as #has_many, #belongs_to
and #has_one_through.

Inspired by Rails' VC, RailsLite is a light-weight backend framework featuring
RESTful routes, controller inheritance, view templates, sessions, flash,
strong params, and serving of cached static assets. To keep user credentials
secure, Bcrypt is used to store salted password hashes; user passwords are NEVER
stored on the database.

## How to use on a local machine

#### Ruby installation

To run QuickTasks on your local machine, you need Ruby. For OS X systems, you
can prepare to install Ruby by doing the following:

* Install XCode
    * Search and install XCode from the App Store.
* Install Apple Command Line Tools
    * Open XCode (this just needs to run once to initialize it) and close it.
    * Install XCode command line tools by running `xcode-select --install` in
    the terminal.
* Install [Homebrew][homebrew]
    * Run `brew update` to make sure all your formulas are current
* Install git:
    * In the terminal, run `brew install git`.
* Install the readline library:
    * In the terminal, run `brew install readline`.
* Install OpenSSL:
    * In the terminal, run `brew install openssl`

Now we can start install rbenv, a Ruby version manager. Follow the instructions
[here][rbenv-install-osx]. After that, add
`if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi` to your
`~/.bash_profile` to make sure rbenv hooks into your shell.

To finally install Ruby, close your terminal window and open a new one. Install
Ruby using `CONFIGURE_OPTS="--disable-install-rdoc" rbenv install 2.1.2 -v`. You
could use any version, but I used 2.1.2 for this.

Next, specify which Ruby is used by default with `rbenv global 2.1.2`.

Confirm that Ruby was installed properly by using `which ruby`. You should see
`/Users/username/.rbenv/shims/ruby`. You don't want to see `/usr/bin/ruby`.

Install bundler with `gem install bundler` to let you install bundled gems.

#### Run the server

In the terminal, clone into this repo using `git clone git@github.com:fndelacruz/QuickTasks`.

`cd` into the QuickTasks folder. Run `bundle install` to install the associated
gems and run `ruby bin/server.rb` to start the server.

Access the application [here][localhost].

## How to use on AWS EC2

#### AWS EC2 setup

Amazon Web Services allows new users to run a low-resource "micro" instance for
free/cheap 24/7 for a whole year. It's a great resource to play with working
"on the cloud" with a remote machine.

Set up a t2.micro instance running Ubuntu Server 14.04 LTS by following the
instructions [here][sitepoint], under "Creating an EC2 Instance". No need to
read the rest of those instructions since we're deploying my custom MVC and not
a Rails App.

Connect to your micro instance with `ssh -i "your_key.pem" ubuntu@your.server.ip.address`,
where "your_key.pem" is the full path to the private key associated with that
instance's security group.

#### Ruby installation

Install rbenv and Ruby by following the [instructions][digitalocean] under
the "Install rbenv" and "Install Ruby" headings. You can skip the rest of the
instructions for the same reason above.

#### Run the server

In the terminal, clone into this repo using `git clone git@github.com:fndelacruz/QuickTasks`.

`cd` into the QuickTasks folder. Run `bundle install` to install the associated
gems.

AWS doesn't let you run anything directly on ports 1024 or below for security
reasons. So, how do we run our app on standard HTTP port 80? Use iptables to
forward incoming TCP traffic from port 80 to 3000:

```
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
```

Finally, run `ruby bin/server.rb` to start the server. You can access the
QuickTasks app by pointing your browser to your instance's address/hostname.

You may notice that after closing the SSH connection with your instance, the
web server is no longer running. To persist the application, use [screen][screen].
The next time you SSH into your instance, type `screen` to open a new screen and
run `ruby bin/server.rb` as usual. Detach from the screen and close the SSH
connection. Enjoy your free, persistent AWS server!

#### Issues

My initial configuration of `Rack::Server` looked like this:

```ruby
Rack::Server.start(
  app: app,
  Port: 3000,
  Host: 'localhost'
)
```

This ran fine when running a local server, but did not work when running on AWS.

Starting with [Rails 4.2][rails-4.2-notes], Rack by default listens on
`localhost` instead of `0.0.0.0` for [security reasons][rack-diff]. Running Rack
on another machine (eg AWS EC2) requires Host set to `0.0.0.0` as part of the
Rack::Server.start options:

```ruby
Rack::Server.start(
  app: app,
  Port: 3000,
  Host: '0.0.0.0'
)
```

Setting host to `0.0.0.0` still allows you to run the server locally, so I kept
that as the default Host setting.

[live]: http://www.quicktasks.club

[homebrew]: http://brew.sh/
[rbenv-install-osx]: https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x
[localhost]: http://localhost:3000/

[sitepoint]: https://www.sitepoint.com/deploy-your-rails-app-to-aws/
[digitalocean]: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04

[screen]: https://www.gnu.org/software/screen/manual/screen.html

[rails-4.2-notes]: http://guides.rubyonrails.org/4_2_release_notes.html#default-host-for-rails-server
[rack-diff]: https://github.com/rack/rack/commit/28b014484a8ac0bbb388e7eaeeef159598ec64fc
