module Web::Views::Users
  class Edit
    include Web::View
    def user_form
      form_for :user, routes.user_path(id: user.id), method: :patch, values: { user: user } do
        fields.each do |field|
          div(class: 'formgroup mb-4') do
            label field
            text_field field, class: 'form-control'
          end
        end
        submit 'Submit', class: ['btn', 'btn-primary', 'mt-2']
      end
    end

    private

    def fields
      %i[nickname password twitch_link]
    end
  end
end
