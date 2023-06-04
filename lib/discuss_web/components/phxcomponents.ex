defmodule DiscussWeb.PhxComponents do
  use Phoenix.Component

  import DiscussWeb.CoreComponents

  attr(:type, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def phxbutton(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "relative p-0.5 inline-flex items-center justify-center font-bold overflow-hidden group/button rounded-3xl active:shadow-md active:scale-95 active:ring-2 active:ring-offset-2 active:ring-phx-2 transition-all duration-200",
        @class
      ]}
      {@rest}
    >
      <span class="w-full h-full bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3 group-hover/button:from-phx-3 group-hover/button:via-phx-2 group-hover/button:to-phx-1 absolute">
      </span>
      <span class="relative px-3 py-1 transition-all ease-out bg-white rounded-3xl group-hover/button:bg-opacity-0 duration-400">
        <span class="relative bg-clip-text bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3 text-transparent group-hover/button:text-white">
          <%= render_slot(@inner_block) %>
        </span>
      </span>
    </button>
    """
  end

  attr(:method, :string, default: nil)
  attr(:href, :string, default: nil)
  attr(:navigate, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def phxlink(assigns) do
    ~H"""
    <.link
      class={[
        "relative",
        @class
      ]}
      method={@method}
      href={@href}
      navigate={@navigate}
      {@rest}
    >
      <span class="px-0.5 group/link relative inline-block bg-clip-text bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3 text-transparent transition-all">
        <span class="absolute bottom-0 left-0 right-0 h-0.5 w-0 group-hover/link:w-full m-auto transition-all rounded-md bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3">
        </span>
        <%= render_slot(@inner_block) %>
      </span>
    </.link>
    """
  end

  attr(:method, :string, default: nil)
  attr(:href, :string, default: nil)
  attr(:navigate, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def phxback(assigns) do
    ~H"""
    <span class="mt-16 inline-block">
      &nbsp;
    </span>
    <.phxlink class={@class} method={@method} href={@href} navigate={@navigate} {@rest}>
      <.icon
        name="hero-chevron-left-solid"
        class="bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3 h-3 w-3 line-height-0 text-transparent"
      /> <%= render_slot(@inner_block) %>
    </.phxlink>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def badge(assigns) do
    ~H"""
    <span
      class={[
        "leading-6 bg-gradient-to-br from-phx-1 via-phx-2 to-phx-3 text-white rounded-full px-2 font-medium transition-all duration-400 hover:scale-110 ease-in-out",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
