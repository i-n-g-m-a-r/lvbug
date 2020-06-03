defmodule LvbugWeb.EmailInput do
  use Phoenix.LiveComponent

  defstruct [:value, :foobar]

  def render(assigns) do
    ~L"""
      <div id="<%= assigns.id %>">
        <ul>
          <%= render_error(assigns) %>
          <li><%= email_input(assigns) %></li>
          <li><%= next_button(assigns) %></li>
        </ul>
      </div>
    """
  end

  def update(%{id: id, email: email} = _assigns, socket) do
    assigns = [
      id: id,
      state: %__MODULE__{value: email, foobar: 0}
    ]
    socket = assign(socket, assigns)
    IO.inspect "initialized: `#{inspect(socket.assigns.state)}`"
    {:ok, socket}
  end

  def handle_event("next", %{"value" => "Next"}, socket) do
    state  = socket.assigns.state
    foobar = state.foobar + 1
    socket = assign(socket, state: %{state | foobar: foobar})
    IO.inspect "next clicked: `#{inspect(socket.assigns.state)}`"
    {:noreply, socket}
  end

  ## private

  defp render_error(%{state: %{foobar: foobar}} = assigns) when foobar === 3 do
    # boom!
    IO.inspect "Email input value is set to \"Next\": `#{inspect(assigns.state)}`"
    Phoenix.HTML.Tag.content_tag :li, "Invalid"
  end

  defp render_error(_), do: []

  defp email_input(assigns) do
    IO.inspect "email_input: `#{inspect(assigns.state)}`"
    Phoenix.HTML.Tag.tag :input, [
      type: "email",
      name: "email",
      value: assigns.state.value
    ]
  end

  defp next_button(assigns), do:
    Phoenix.HTML.Tag.tag :input, [
      type: "button",
      value: "Next",
      "phx-click": "next",
      "phx-target": assigns.myself
    ]

end