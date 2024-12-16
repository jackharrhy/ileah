defmodule Mix.Tasks.VoiceTest do
  use Mix.Task

  @impl Mix.Task
  @requirements ["app.start"]
  def run(_args) do
    :ok = ILeah.Voice.text_to_speech_file("Hello, world!", "hello.mp3")
  end
end
