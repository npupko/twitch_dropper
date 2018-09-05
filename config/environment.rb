require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/twitch_dropper'
require_relative '../apps/web/application'

Haml::TempleEngine.disable_option_validator!

Hanami.configure do
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/twitch_dropper_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/twitch_dropper_development'
    #    adapter :sql, 'mysql://localhost/twitch_dropper_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/twitch_dropper/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end
