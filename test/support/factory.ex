defmodule Corker.Factory do
  use ExMachina.Ecto, repo: Corker.Repo

  alias Corker.Accounts.User

  def user_factory do
    %User{
      slack_id: Faker.String.base64(),
      username: Faker.Internet.user_name()
    }
  end

  def slack_user_factory do
    username = Faker.Internet.user_name()
    first_name = Faker.Name.first_name()
    last_name = Faker.Name.last_name()
    full_name = "#{first_name} #{last_name}"

    %{
      color: Faker.Color.rgb_hex(),
      deleted: false,
      id: Faker.String.base64(),
      is_admin: false,
      is_app_user: false,
      is_bot: false,
      is_owner: false,
      is_primary_owner: false,
      is_restricted: false,
      is_ultra_restricted: false,
      name: username,
      presence: ["online", "away"] |> Enum.random(),
      profile: %{
        avatar_hash: Faker.String.base64(),
        display_name: username,
        display_name_normalized: username,
        email: Faker.Internet.safe_email(),
        fields: [],
        first_name: first_name,
        image_192: Faker.Avatar.image_url(),
        image_24: Faker.Avatar.image_url(),
        image_32: Faker.Avatar.image_url(),
        image_48: Faker.Avatar.image_url(),
        image_512: Faker.Avatar.image_url(),
        image_72: Faker.Avatar.image_url(),
        last_name: last_name,
        phone: Faker.Phone.EnGb.number(),
        real_name: full_name,
        real_name_normalized: full_name,
        skype: "",
        status_emoji: "",
        status_expiration: 0,
        status_text: "",
        status_text_canonical: "",
        team: Faker.String.base64(),
        title: Faker.Company.bullshit()
      },
      real_name: full_name,
      team_id: Faker.String.base64(),
      tz: "Europe/London",
      tz_label: "British Summer Time",
      tz_offset: 3600,
      updated: 1_504_452_720
    }
  end
end
