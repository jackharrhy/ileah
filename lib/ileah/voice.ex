defmodule ILeah.Voice do
  @api_base "https://api.elevenlabs.io/v1"

  @voice_id "r7zTrIXGoj9V1f7XzeIj"

  def text_to_speech(text) do
    url = "#{@api_base}/text-to-speech/#{@voice_id}"

    body = %{
      text: text,
      model_id: "eleven_multilingual_v2",
      voice_settings: %{
        stability: 0.35,
        similarity_boost: 0.90,
        style: 0,
        use_speaker_boost: true
      }
    }

    Req.post!(
      url,
      json: body,
      headers: [
        {"Content-Type", "application/json"},
        {"xi-api-key", Application.get_env(:ileah, :elevenlabs_api_key)}
      ]
    )
  end

  def text_to_speech_file(text, output_path) do
    %{status: 200, body: body} = text_to_speech(text)
    File.write(output_path, body)
    :ok
  end
end
