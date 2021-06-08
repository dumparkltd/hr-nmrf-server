# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class Seeds
  def initialize
    base_seeds!
    run_env_seeds!
  end

  private

  def run_env_seeds!
    send("#{Rails.env}_seeds!")
  rescue NameError
    log "Seeds for #{Rails.env} not defined, skipping.", level: :warn
  end

  def base_seeds!
    # Set up user roles
    Role.new(name: 'admin', friendly_name: 'Admin').save!
    Role.new(name: 'manager', friendly_name: 'Manager').save!
    Role.new(name: 'contributor', friendly_name: 'Contributor').save!

    # set up frameworks
    dflt = Framework.new(
        title: 'Default',
        short_title: 'Default',
        has_indicators: false,
        has_measures: true,
        has_response: true,
      )
    dflt.save!

    # Set up taxonomies
    # Subject taxonomies
    stype = FactoryGirl.create(
        :taxonomy,
        framework:dflt,
        title: 'Subject type',
        tags_users: false,
        allow_multiple: false,
        has_manager: false,
        priority: 1,
        is_smart: false,
      )
    FactoryGirl.create(
      :framework_taxonomy,
      framework:dflt,
      taxonomy:stype,
    )
    orgtype = FactoryGirl.create(
        :taxonomy,
        framework:dflt,
        title: 'Subject type',
        tags_users: false,
        allow_multiple: false,
        has_manager: false,
        priority: 1,
        is_smart: false,
      )
    FactoryGirl.create(
      :framework_taxonomy,
      framework:dflt,
      taxonomy:orgtype,
    )
    grouptype = FactoryGirl.create(
        :taxonomy,
        framework:dflt,
        title: 'Group type',
        tags_users: false,
        allow_multiple: false,
        has_manager: false,
        priority: 1,
        is_smart: false,
      )
    FactoryGirl.create(
      :framework_taxonomy,
      framework:dflt,
      taxonomy:grouptype,
    )

    # Action taxonomies
    atype = FactoryGirl.create(
        :taxonomy,
        title: 'Activity types',
        tags_measures: true,
        priority: 1,
      )

    legal = FactoryGirl.create(
        :taxonomy,
        title: 'Legally binding',
        tags_measures: true,
        priority: 6,
      )

    strategytype = FactoryGirl.create(
        :taxonomy,
        title: 'Strategy type',
        tags_measures: true,
        priority: 7,
      )

    admintype = FactoryGirl.create(
        :taxonomy,
        title: 'Administration type',
        tags_measures: true,
        priority: 7,
      )

  end

  def development_seeds!
    return unless User.count.zero?
    FactoryGirl.create(:user).tap do |user|
      log "Seed user created: Log in with #{user.email} and password #{user.password}"
      user.roles << Role.find_by(name: 'manager')
      user.save!
    end

    # create test data, configure in spec/factories/
    # FactoryGirl.create_list(:recommendation, 50)
    # FactoryGirl.create_list(:measure, 50)
    # FactoryGirl.create_list(:indicator, 50)

    # FactoryGirl.create_list(:category, 10, taxonomy: org)
  end

  def log(msg, level: :info)
    Rails.logger.public_send(level, msg)
  end
end

Seeds.new
