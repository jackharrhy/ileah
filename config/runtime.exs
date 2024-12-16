import Config
import Dotenvy

source!([".env", System.get_env()])

config :nostrum,
  token: env!("ILEAH_BOT_TOKEN", :string!),
  youtubedl: nil,
  streamlink: nil,
  gateway_intents: [
    :guilds,
    :guild_messages,
    :message_content
  ]

config :ileah,
  elevenlabs_api_key: env!("ILEAH_ELEVENLABS_API_KEY", :string!),
  owner_id: env!("ILEAH_OWNER_ID", :integer!)
