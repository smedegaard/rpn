defmodule Rpn.Supervisor do
  use Supervisor

  def start_link do
    children = [
      {Rpn.Engine, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
