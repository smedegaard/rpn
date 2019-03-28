defmodule Rpn.Engine do

  @moduledoc """
  Documentation for Reverse Polish Notation calulator.
  """

  use GenServer

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, :na, name: __MODULE__)
  end

  def push(rpn_pid, item) do
    GenServer.call(rpn_pid, {:push, item})
  end

  def peek(rpn_pid) do
    GenServer.call(rpn_pid, :peek)
  end

  def reset(rpn_pid) do
    GenServer.cast(rpn_pid, :reset)
  end

  # Server callbacks
  @impl true
  def init(:na) do
    IO.inspect "Got started by supervisor"
    {:ok, []}
  end

  @impl true
  def handle_cast(:reset, _state) do
    {:noreply, []}
  end

  @impl true
  def handle_call({:push, number}, from, state) when is_number(number) do
    {:reply, :ok, [number | state]}
  end

  def handle_call({:push, :/}, _from, [_x, 0 | _list] = state) do
    response = {:error, :division_by_zero}
    {:reply, response, state}
  end

  @operands [:+, :/, :-, :*]
  def handle_call({:push, op}, _from, [x, y | list]) when op in @operands do
    result = apply(Kernel, op, [x, y])
    new_state = [result | list]
    {:reply, result, new_state}
  end

  def handle_call({:push, otherwise}, _from, state) do
    response = {:error, {:unexpected_input, otherwise}}
    {:reply, response, state}
  end

  def handle_call(:peek, _from, state) do
    {:reply, state, state}
  end
end
