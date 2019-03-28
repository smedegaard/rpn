defmodule Rpn.EngineTest do
  use ExUnit.Case
  doctest Rpn.Engine

  setup do
    {:ok, pid} = Rpn.Engine.start_link()
    {:ok, %{pid: pid}}
  end

  describe "mathematics!" do
    test "should add numbers", %{pid: pid} do
      assert :ok = Rpn.Engine.push(pid, 5)
      assert :ok = Rpn.Engine.push(pid, 5)
      assert 10 == Rpn.Engine.push(pid, :+)
    end

    test "should return error on division by zero", %{pid: pid} do
      assert :ok = Rpn.Engine.push(pid, 0)
      assert :ok = Rpn.Engine.push(pid, 5)
      assert {:error, :division_by_zero} == Rpn.Engine.push(pid, :/)
    end
  end

end
