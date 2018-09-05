module Web::Views::Users
  class Index
    include Web::View

    def enable_worker_button(user)
      if user.worker_status
        enabled_button(user)
      else
        disabled_button(user)
      end
    end

    def screenshot_updated_time(user)
      screenshot_path = Hanami.root.join('public', 'screenshots', "#{user.id}_screenshot.png")
      update_date = File.mtime(screenshot_path)
      time_diff = Time.now - update_date
      formatted_time = Time.at(time_diff).utc.strftime("%_H hours %_M minutes %_S seconds")
      formatted_time.gsub(/((?<=\A)|(?<=\s))0\s\w+\s/, '')
    end

    private

    def enabled_button(user)
      form_for :user, routes.user_path(id: user.id), method: :patch, style: 'display: inline-block;' do
        hidden_field :worker_status, value: false
        submit 'Disable Twitch', class: ['btn', 'btn-outline-danger']
      end
    end

    def disabled_button(user)
      form_for :user, routes.user_path(id: user.id), method: :patch, style: 'display: inline-block;' do
        hidden_field :worker_status, value: true
        submit 'Enable Twitch', class: ['btn', 'btn-outline-success']
      end
    end
  end
end
