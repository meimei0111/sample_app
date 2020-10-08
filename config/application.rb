require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')] # it will load all file at locales folder and, only read rm anf yml file for i18n

    config.i18n.default_locale = :en # language default project
    I18n.available_locales = [:en] # define all laguage that you project allow

		# Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
