defmodule SkylineGoogle.Gmail do
  def get_authenticated_token do
    with {:ok, %{token: token}} <-
           Goth.Token.for_scope(
             "https://www.googleapis.com/auth/gmail.compose",
             "it_bot@org"
           ) do
      token
    else
      error -> error
    end
  end
end
