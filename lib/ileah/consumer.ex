defmodule ILeah.ExampleConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias ILeah.Voice

  def blow_up(msg) do
    ya_prefix = String.duplicate("ya", Enum.random(3..5))
    ya_suffix = String.duplicate("ya", Enum.random(2..3))
    Api.create_message(msg.channel_id, ya_prefix <> " blow up " <> ya_suffix)
  end

  def is_permitted(msg) do
    msg.author.id in Application.get_env(:ileah, :owner_ids)
  end

  def leah_say(msg, text) do
    if is_permitted(msg) do
      case Voice.text_to_speech(text) do
        %{status: 200, body: body} ->
          Api.create_message(msg.channel_id,
            file: %{
              name: "leah_say.mp3",
              body: body
            },
            message_reference: %{message_id: msg.id}
          )

        response ->
          IO.puts("Error: Failed to convert text to speech: #{inspect(response)}")

          Api.create_message(
            msg.channel_id,
            content: "oh no, failed to convert text to speech",
            message_reference: %{message_id: msg.id}
          )
      end
    else
      Api.create_message(msg.channel_id, "you cannot use this command, blow up")
    end
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "blow up" ->
        if is_permitted(msg) do
          :ignore
        else
          blow_up(msg)
        end

      "leah say " <> text ->
        leah_say(msg, text)

      _ ->
        :ignore
    end
  end
end
