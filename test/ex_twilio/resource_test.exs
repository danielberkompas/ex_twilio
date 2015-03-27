defmodule ExTwilio.ResourceTest do
  use ExUnit.Case
  alias ExTwilio.Api
  import Mock

  defmodule TestResource do
    use ExTwilio.Resource, import: [:stream, :all, :list, :find, :create, :update, :destroy]
  end

  test "only imports specified methods" do
    defmodule ExclusiveMethods do
      use ExTwilio.Resource, import: [:stream]
    end

    Enum.each [:all, :list, :find, :create, :update, :destroy], fn(method) ->
      assert_raise UndefinedFunctionError, fn ->
        apply ExclusiveMethods, method, ["id"]
      end
    end
  end

  test ".stream should delegate to Api.stream" do
    with_mock Api, [stream: fn(_, _) -> nil end] do
      TestResource.stream(page_size: 1)
      assert called Api.stream(TestResource, [page_size: 1])
    end
  end

  test ".all should delegate to Api.all" do
    with_mock Api, [all: fn(_) -> nil end] do
      TestResource.all
      assert called Api.all(TestResource)
    end
  end

  test ".list should delegate to Api.list" do
    with_mock Api, [list: fn(_, _) -> nil end] do
      TestResource.list(page_size: 1)
      assert called Api.list(TestResource, [page_size: 1])
    end
  end

  test ".find should delegate to Api.find" do
    with_mock Api, [find: fn(_, _) -> nil end] do
      TestResource.find("id")
      assert called Api.find(TestResource, "id")
    end
  end

  test ".create should delegate to Api.create" do
    with_mock Api, [create: fn(_, _) -> nil end] do
      TestResource.create(field: "value")
      assert called Api.create(TestResource, [field: "value"])
    end
  end

  test ".update should delegate to Api.update" do
    with_mock Api, [update: fn(_, _, _) -> nil end] do
      TestResource.update("id", field: "value")
      assert called Api.update(TestResource, "id", [field: "value"])
    end
  end

  test ".destroy should delegate to Api.destroy" do
    with_mock Api, [destroy: fn(_, _) -> nil end] do
      TestResource.destroy("id")
      assert called Api.destroy(TestResource, "id")
    end
  end

  test ".next_page should delegate to Api.fetch_page with 'next_page_uri'" do
    with_mock Api, [fetch_page: fn(_, _) -> nil end] do
      meta = %{ "next_page_uri" => "next_page" }
      TestResource.next_page(meta)
      assert called Api.fetch_page(TestResource, "next_page")
    end
  end

  test ".previous_page should delegate to Api.fetch_page with 'previous_page_uri'" do
    with_mock Api, [fetch_page: fn(_, _) -> nil end] do
      meta = %{ "previous_page_uri" => "previous_page" }
      TestResource.previous_page(meta)
      assert called Api.fetch_page(TestResource, "previous_page")
    end
  end

  test ".first_page should delegate to Api.fetch_page with 'first_page_uri'" do
    with_mock Api, [fetch_page: fn(_, _) -> nil end] do
      meta = %{ "first_page_uri" => "first_page" }
      TestResource.first_page(meta)
      assert called Api.fetch_page(TestResource, "first_page")
    end
  end

  test ".last_page should delegate to Api.fetch_page with 'last_page_uri'" do
    with_mock Api, [fetch_page: fn(_, _) -> nil end] do
      meta = %{ "last_page_uri" => "last_page" }
      TestResource.last_page(meta)
      assert called Api.fetch_page(TestResource, "last_page")
    end
  end
end
