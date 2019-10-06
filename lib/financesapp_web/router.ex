defmodule FinancesappWeb.Router do
  use FinancesappWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug FinancesappWeb.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: FinancesappWeb.Schema
  end
end
