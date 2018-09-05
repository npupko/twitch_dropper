module Services
  class CaptchaSolver
    def call(key = nil)
      @googlekey = key
      response = solve.body
      @captcha_id = formatted(response)
      puts response
      loop do
        puts 'result'
        sleep 5
        @answer = formatted(answer)
        break unless @answer.nil?
      end
      @answer
    end

    def formatted(response)
      response.match(/OK\|(.*)/)[1]
    rescue
      nil
    end

    def solve
      RestClient.get('http://rucaptcha.com/in.php', params: solve_params)
    end

    def solve_params
      {
        key: ENV.fetch('RUCAPTCHA_KEY'),
        method: 'userrecaptcha',
        googlekey: @googlekey,
        pageurl: 'https://twitch.tv'
      }
    end

    def answer
      RestClient.get('http://rucaptcha.com/res.php', params: answer_params)
    end

    def answer_params
      {
        key: ENV.fetch('RUCAPTCHA_KEY'),
        action: 'get',
        id: @captcha_id
      }
    end
  end
end
