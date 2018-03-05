defmodule ExTwilio.ResourceTest do
  use ExUnit.Case
  alias ExTwilio.Api
  import Mock

  defmodule TestResource do
    defstruct sid: nil
    use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]
  end

  test "only imports specified methods" do
    defmodule ExclusiveMethods do
      defstruct sid: nil
      use ExTwilio.Resource, import: [:stream]
    end

    Enum.each([:all, :list, :find, :create, :update, :destroy], fn method ->
      assert_raise UndefinedFunctionError, fn ->
        apply(ExclusiveMethods, method, ["id"])
      end
    end)
  end

  test ".new should return the module's struct" do
    assert %TestResource{} == TestResource.new()
    assert %TestResource{sid: "hello"} == TestResource.new(sid: "hello")
  end

  test ".find should delegate to Api.find" do
    with_mock Api, find: fn _, _, _ -> nil end do
      TestResource.find("id")
      assert called(Api.find(TestResource, "id", []))
    end
  end

  test ".create should delegate to Api.create" do
    with_mock Api, create: fn _, _, _ -> nil end do
      TestResource.create(field: "value")
      assert called(Api.create(TestResource, [field: "value"], []))
    end
  end

  test ".update should delegate to Api.update" do
    with_mock Api, update: fn _, _, _, _ -> nil end do
      TestResource.update("id", field: "value")
      assert called(Api.update(TestResource, "id", [field: "value"], []))
    end
  end

  test ".destroy should delegate to Api.destroy" do
    with_mock Api, destroy: fn _, _, _ -> nil end do
      TestResource.destroy("id")
      assert called(Api.destroy(TestResource, "id", []))
    end
  end
end
