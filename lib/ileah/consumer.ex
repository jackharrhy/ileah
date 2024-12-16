defmodule ILeah.ExampleConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "blow up" ->
        Api.create_message(msg.channel_id, "ya ya ya ya blow up ya ya")
      _ ->
        :ignore
    end
  end
end
