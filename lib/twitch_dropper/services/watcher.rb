module Services
  class Watcher
    def call(user:)
      @user = user
      setup_capybara!
      perform_login!
      loop_session!
    end

    def loop_session!
      loop do
        break unless worker_status?
        browser.save_and_open_screenshot(screenshot_path)
        sleep 30
      end
    end

    def worker_status?
      UserRepository.new.users.select(:worker_status).where(id: @user.id).first.worker_status
    end

    def screenshot_path
      @screenshot_path ||= Hanami.root.join('public', 'screenshots', "#{@user.id}_screenshot.png")
    end

    def setup_capybara!
      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end

      Capybara.register_driver :headless_chrome do |app|
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: %w(headless disable-gpu) }
        )

        Capybara::Selenium::Driver.new app,
          browser: :chrome,
          desired_capabilities: capabilities
      end

      Capybara.default_driver = :headless_chrome
      Capybara.javascript_driver = :poltergeist
    end

    def browser
      @browser ||= Capybara.current_session
    end

    def open_login_form!
      browser.visit "https://twitch.tv/#{@user.twitch_link}"
      browser.find(:xpath, '//*[@id="root"]/div/div[2]/nav/div/div[5]/div/div[1]/button').click
    end

    def enter_username_and_password!
      username_input = browser.find(:xpath, '/html/body/div[2]/div/div/div/div[1]/form/div/div[1]/div/div[2]/input').fill_in(with: @user.nickname)
      pass_input = browser.find(:xpath, '/html/body/div[2]/div/div/div/div[1]/form/div/div[2]/div/div[1]/div[2]/input').fill_in(with: @user.password)
      login_form_button = xpath('/html/body/div[2]/div/div/div/div[1]/form/div/div[3]/button').click
    end

    def perform_login!
      open_login_form!
      enter_username_and_password!
      fight_with_captcha!
      submit_button = xpath('/html/body/div[2]/div/div/div/div[1]/div[3]/div/button')
      browser.save_and_open_screenshot
      submit_button.click
    end

    def fight_with_captcha!
      captcha = xpath('//*[@id="recaptcha-element-container"]/div/div/iframe')
      google_key = captcha[:src].match(/&k=(.*)&co=/)[1]
      response = captcha_solver.call(google_key).body
      puts "Response: #{response}"
      browser.execute_script("document.querySelector('#g-recaptcha-response').setAttribute('style', 'display: block;')")
      textarea_response = xpath('//*[@id="g-recaptcha-response"]').fill_in(with: response)
      browser.execute_script("___grecaptcha_cfg.clients[0].aa.l.callback('#{response}')")
    end

    def captcha_solver
      @captcha_solver ||= Services::CaptchaSolver.new
    end

    def xpath(path, **args)
      @browser.find(:xpath, path, **args)
    end
  end
end
