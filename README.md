# QuickTasks

[Live!][live]

## Summary

QuickTasks is a demonstration checklist application built on top of a
custom-built MVC framework modeled after Rails. I built this framework to
have a stronger understanding of what goes on under the Rails hood.

The framework consists of two major components: ActiveRecordLite, an ORM that
abstracts SQL entries as models, and RailsLite, a backend framework featuring
RESTful routes, controller inheritance, view templates, sessions, flash,
strong params, and serving of cached static assets. To keep user credentials
secure, Bcrypt is used to store salted password hashes; user passwords are NEVER
stored on the database.

## ActiveRecordLite

## RailsLite

### Router

### Controller

ControllerBase

#### View Templates

#### Sessions

#### Flash

#### Strong Params

#### Static Assets

Cache...

### User Authentication

## Deployment

### AWS EC2

Starting with [Rails 4.2][rails-4.2-notes], Rack by default listens on
`localhost` instead of `0.0.0.0` for [security reasons][rack-diff]. Running Rack
on another machine (eg AWS EC2) requires Host set to 0.0.0.0 as part of the
Rack::Server.start options:

```ruby
Rack::Server.start(
  app: app,
  Port: 3000,
  Host: '0.0.0.0'
)
```

AWS doesn't let you run anything directly on ports 1024 or below for security
reasons. So, how do we run our app on standard http port 80? Use iptables to
forward incoming TCP traffic from port 80 to 3000:

```
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
```

[live]: http://pending-url-on-amazon
[rails-4.2-notes]: http://guides.rubyonrails.org/4_2_release_notes.html#default-host-for-rails-server
[rack-diff]: https://github.com/rack/rack/commit/28b014484a8ac0bbb388e7eaeeef159598ec64fc
