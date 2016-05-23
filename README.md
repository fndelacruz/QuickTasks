# ActiveRecordLite

## AWS Deployment

Starting with [Rails 4.2](http://guides.rubyonrails.org/4_2_release_notes.html#default-host-for-rails-server), Rack by default listens on `localhost` instead of `0.0.0.0` for [security reasons](https://github.com/rack/rack/commit/28b014484a8ac0bbb388e7eaeeef159598ec64fc). Running Rack on another machine (eg AWS EC2) requires the Host to be defined as 0.0.0.0 as part of the Rack::Server.start options:

```ruby
Rack::Server.start(
  app: app,
  Port: 3000,
  Host: '0.0.0.0'
)
```

Amazon doesn't let you run anything directly on ports 1024 or below for security reasons. So, how do we run our app on standard http port 80? Use iptables to forward incoming TCP traffic from port 80 to 3000:

```
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
```
