defmodule ILeah.Bot.Commands.LeahSay do
  alias ILeah.Voice
  alias Nostrum.Api
  alias Nostrum.Constants.InteractionCallbackType
  alias Nostrum.Constants.ApplicationCommandOptionType

  def definition do
    %{
      name: "leah-say",
      description: "Have iLeah say something using text-to-speech",
      options: [
        %{
          type: ApplicationCommandOptionType.string(),
          name: "text",
          description: "Text for iLeah to say",
          required: true
        }
      ]
    }
  end

  def handle(interaction) do
    if ILeah.Bot.is_permitted(interaction) do
      text = get_text_option(interaction)

      case Voice.text_to_speech(text) do
        %{status: 200, body: body} ->
          Api.Interaction.create_response(interaction, %{
            type: InteractionCallbackType.channel_message_with_source(),
            data: %{
              files: [
                %{
                  name: "leah_say.mp3",
                  body: body
                }
              ]
            }
          })

        response ->
          IO.puts("Error: Failed to convert text to speech: #{inspect(response)}")

          Api.Interaction.create_response(interaction, %{
            type: InteractionCallbackType.channel_message_with_source(),
            data: %{
              content: "oh no, failed to convert text to speech"
            }
          })
      end
    else
      Api.Interaction.create_response(interaction, %{
        type: InteractionCallbackType.channel_message_with_source(),
        data: %{
          content: "you cannot use this command, blow up"
        }
      })
    end
  end

  defp get_text_option(interaction) do
    case interaction.data.options do
      nil ->
        ""

      options ->
        Enum.find_value(options, "", fn option ->
          if option.name == "text", do: option.value, else: nil
        end)
    end
  end
end
