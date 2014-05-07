Curarium::Application.config.local = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]
