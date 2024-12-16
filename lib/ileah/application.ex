defmodule ILeah.Application do
  use Application

  def start(_type, _args) do
    children = [ILeah.ExampleConsumer]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
