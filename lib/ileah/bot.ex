defmodule ILeah.Bot do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Nostrum.Constants.InteractionCallbackType

  alias ILeah.Bot.Commands.{
    LeahSay
  }

  def handle_event(
        {:INTERACTION_CREATE, %Interaction{type: 2, data: %{name: name}} = interaction, _ws_state}
      ) do
    handle_slash_command(name, interaction)
  end

  def handle_event(
        {:INTERACTION_CREATE, %Interaction{type: 3, data: %{custom_id: custom_id}} = interaction,
         _ws_state}
      ) do
    handle_message_component(custom_id, interaction)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "blow up" ->
        if is_permitted(msg) do
          :ignore
        else
          blow_up(msg)
        end

      _ ->
        :ignore
    end
  end

  def handle_event(_), do: :ok

  def blow_up(msg) do
    ya_prefix = String.duplicate("ya", Enum.random(3..5))
    ya_suffix = String.duplicate("ya", Enum.random(2..3))
    Api.Message.create(msg.channel_id, ya_prefix <> " blow up " <> ya_suffix)
  end

  def is_permitted(%{author: %{id: id}}), do: id in Application.get_env(:ileah, :owner_ids)
  def is_permitted(%{user: %{id: id}}), do: id in Application.get_env(:ileah, :owner_ids)

  defp handle_slash_command("leah-say", interaction) do
    LeahSay.handle(interaction)
  end

  defp handle_slash_command(command_name, interaction) do
    response = %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        content: "Unknown command: #{command_name}"
      }
    }

    Api.Interaction.create_response(interaction, response)
  end

  defp handle_message_component(custom_id, interaction) do
    response = %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        content: "Unknown component interaction: #{custom_id}"
      }
    }

    Api.Interaction.create_response(interaction, response)
  end
end
