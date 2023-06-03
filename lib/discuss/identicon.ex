defmodule Identicon do
  @pixel_size 140

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(@pixel_size * 5, @pixel_size * 5)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {{x1, y1}, {x2, y2}} ->
      :egd.filledRectangle(
        image,
        {x1 * @pixel_size, y1 * @pixel_size},
        {x2 * @pixel_size, y2 * @pixel_size},
        fill
      )
    end)

    :egd.render(image)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_, index} ->
        x = rem(index, 5)
        y = div(index, 5)
        top_left = {x, y}
        bottom_right = {x + 1, y + 1}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {value, _} ->
        rem(value, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _] = row
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
