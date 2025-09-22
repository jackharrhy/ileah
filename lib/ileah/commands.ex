defmodule ILeah.Commands do
  alias Nostrum.Api
  alias ILeah.Bot.Commands.LeahSay

  def ensure_ready do
    case Nostrum.Cache.Me.get() do
      nil ->
        Mix.shell().info("Waiting for Nostrum to connect...")
        :timer.sleep(1000)
        ensure_ready()

      _user ->
        :ok
    end
  end

  def all_commands do
    [
      LeahSay.definition()
    ]
  end

  def create_global_commands do
    ensure_ready()
    commands = all_commands()

    results =
      Enum.map(commands, fn command ->
        case Api.ApplicationCommand.create_global_command(command) do
          {:ok, created_command} ->
            {:success, created_command}

          {:error, error} ->
            {:error, command.name, error}
        end
      end)

    successes =
      results
      |> Enum.filter(&match?({:success, _}, &1))
      |> Enum.map(fn {:success, command} -> command end)

    errors =
      results
      |> Enum.filter(&match?({:error, _, _}, &1))
      |> Enum.map(fn {:error, name, error} -> {name, error} end)

    %{successes: successes, errors: errors}
  end

  def create_guild_commands(guild_id) do
    ensure_ready()
    commands = all_commands()

    results =
      Enum.map(commands, fn command ->
        case Api.ApplicationCommand.create_guild_command(guild_id, command) do
          {:ok, created_command} ->
            {:success, created_command}

          {:error, error} ->
            {:error, command.name, error}
        end
      end)

    successes =
      results
      |> Enum.filter(&match?({:success, _}, &1))
      |> Enum.map(fn {:success, command} -> command end)

    errors =
      results
      |> Enum.filter(&match?({:error, _, _}, &1))
      |> Enum.map(fn {:error, name, error} -> {name, error} end)

    %{successes: successes, errors: errors}
  end
end
