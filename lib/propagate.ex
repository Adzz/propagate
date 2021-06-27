defmodule Network do
  defstruct []

  # We could also do this without agents, we should try that really.
  @doc """
  Sets the cell's value to be whatever we are given.
  """
  def set_value(cell_pid, value) do
    Agent.update(cell_pid, fn _ -> value end)
  end

  def get_value(cell_pid) do
    Agent.get(cell_pid, & &1)
  end
end

defmodule Node do
  defstruct []
end

defmodule Propagate do
  @moduledoc """
  This is porting this blog post into elixir
  https://tgk.github.io/2014/01/getting-hot-with-propagators.html
  """

  @doc """
  We just use floats and live with the inaccuracy for sake of a simple example.
  """
  def fahrenheit_to_celsius(fahrenheit) do
    (fahrenheit - 32) * (5 / 9)
  end

  def celsius_to_fahrenheit(celsius) do
    celsius * (9 / 5) + 32
  end

  # So we need to create nodes that are Celsius cells, and some that are Fahrenheit cells,
  # then we want them to be connected via the two fns described above like so:

  # Celsius -> celsius_to_fahrenheit -> Fahrenheit
  #    ^                                    |
  #    |<----- fahrenheit_to_celsius <------|

  # Crucially we want the cells to propagate when they update themselves. That involves
  # telling the other cell "I've updated here's what you should read". This means a cell
  # has to keep a list of cells it should propagate to.

  {:ok, celsius_cell} = Agent.start_link(fn -> nil end)
  {:ok, fahrenheit_cell} = Agent.start_link(fn -> nil end)

  # So we have a system there are a few approaches to ensuring that stuff propagates. One
  # is to chatter. But as we all know that gets untenable with large number of cells and/or
  # connections. And in this style of programming that is a distinct probability.

  # So there is effort in this space to understand if we can limit the number of nodes
  # that need to be alerted.

  # It feels like another approach may be to keep a list of the connected neighbors but
  # that probably has tradeoffs in that you have to maintain that list.
end
