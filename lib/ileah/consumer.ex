defmodule ILeah.ExampleConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "blow up" ->
        Api.create_message(msg.channel_id, String.duplicate("ya", Enum.random(3..5)) <> " blow up " <> String.duplicate("ya", Enum.random(2..3)))
      _ ->
        :ignore
    end
  end
end
