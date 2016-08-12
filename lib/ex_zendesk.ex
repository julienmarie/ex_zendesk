defmodule ExZendesk do
  use HTTPoison.Base

  @moduledoc """
  Simple [HTTPoison](https://hexdocs.pm/httpoison/overview.html) based helper library to interact with the [Zendesk API](https://developer.zendesk.com/rest_api/docs/core/introduction)

  ## Configuration

  First you must configure the subdomain, username, and password. The library will check environment variables first and fall back to application configuration.

  This library currently supports Basic authentication or API token authentication.

  - subdomain, taken from ZENDESK_SUBDOMAIN environment variable or `Application.get_env(:ex_zendesk, :subdomain)`. This is your zendesk base url, such as https://obscura.zendesk.com

  - user, taken from ZENDESK_USER environment variable or `Application.get_env(:ex_zendesk, :user)`. If using basic authentication, this is your zendesk login (ex. user@gmail.com). If using api token authentication this is your zendesk login followed by /token (ex. user@gmail.com/token)

  - password, taken from ZENDESK_PASSWORD environment variable or `Application.get_env(:ex_zendesk, :password)`. If using basic authentication this is your zendesk password. If using api token authentication put your api token here.

  ## Examples

  ```
  ExZendesk.start

  ExZendesk.get "/api/v2/tickets.json?per_page=1"
    # => {:ok,
    # %HTTPoison.Response{body: %{count: 114,
    #  next_page: "https://storestartup.zendesk.com/api/v2/tickets.json?page=2&per_page=1",
    #  previous_page: nil,
    #  tickets: [%{allow_channelback: false, assignee_id: 1802891567,
    #     brand_id: 572847, collaborator_ids: [],
    #     created_at: "2016-03-01T07:03:12Z", custom_fields: [],
    #     description: "Hello,\r\nThis is a test ticket",
    #     due_at: nil, external_id: nil, fields: [], followup_ids: [],
    #     forum_topic_id: nil, group_id: 26814467, has_incidents: false, id: 38,
    #     organization_id: nil, priority: nil, problem_id: nil,
    #     raw_subject: "Test ticket", recipient: nil,
    #     requester_id: 5022882178, satisfaction_rating: nil,
    #     sharing_agreement_ids: [], status: "closed",
    #     subject: "Test Ticket",
    #     submitter_id: 5022882178, tags: [], type: nil,
    #     updated_at: "2016-05-07T17:01:56Z",
    #     url: "https://storestartup.zendesk.com/api/v2/tickets/38.json",
    #     via: %{channel: "web", source: %{from: %{}, rel: nil, to: %{}}}}]},
    # headers: [{"Server", "nginx"}, {"Date", "Fri, 12 Aug 2016 16:33:01 GMT"},
    # {"Content-Type", "application/json; charset=UTF-8"},
    # {"Content-Length", "1291"}, {"Connection", "keep-alive"},
    # {"X-Zendesk-API-Version", "v2"},
    # {"X-Zendesk-Application-Version", "v3.94.2"},
    # {"X-Zendesk-API-Warn",
    #  "Removed restricted keys [\"_json\"] from parameters according to whitelist"},
    # {"X-Frame-Options", "SAMEORIGIN"}, {"X-Rate-Limit", "700"},
    # {"X-Rate-Limit-Remaining", "699"},
    # {"Strict-Transport-Security", "max-age=31536000;"},
    # {"X-UA-Compatible", "IE=Edge,chrome=1"},
    # {"ETag", "\"8cd9c3920ce86f5b21141e6bcef72358\""},
    # {"Cache-Control", "must-revalidate, private, max-age=0"},
    # {"X-Zendesk-Origin-Server", "app41.pod6.iad1.zdsys.com"},
    # {"X-Request-Id", "5aa337af-21ba-4ef0-ce53-b8ca3a6bb1dc"},
    # {"X-Runtime", "0.188008"}, {"X-Rack-Cache", "miss"},
    # {"X-Zendesk-Request-Id", "1fcdee3a31262d9d3064"},
    # {"X-Content-Type-Options", "nosniff"}], status_code: 200}}

  sample_ticket = %{ticket: %{subject: "testing", comment: %{body: "this is a test"}, requester: %{name: "John Doe", email: "jdoe@gmail.com"}}}

  ExZendesk.post "/api/v2/tickets.json", sample_ticket
    # => {:ok,
    # %HTTPoison.Response{body: %{audit: %{author_id: 1802891567,
    #    created_at: "2016-08-12T16:40:14Z",
    #    events: [%{attachments: [], audit_id: 145382499768, author_id: 9343852848,
    #       body: "this is a test",
    #       html_body: "<div class=\"zd-comment\"><p dir=\"auto\">this is a test</p></div>",
    #       id: 145382499848, public: true, type: "Comment"},
    #     %{field_name: "subject", id: 145382500008, type: "Create",
    #       value: "testing"},
    #     %{field_name: "status", id: 145382500068, type: "Create", value: "open"},
    #     %{field_name: "priority", id: 145382500148, type: "Create", value: nil},
    #     %{field_name: "type", id: 145382500188, type: "Create", value: nil},
    #     %{field_name: "assignee_id", id: 145382500248, type: "Create",
    #       value: "1802891567"},
    #     %{field_name: "group_id", id: 145382500288, type: "Create",
    #       value: "26814467"},
    #     %{field_name: "requester_id", id: 145382500368, type: "Create",
    #       value: "9343852848"},
    #     %{body: "Your request ({{ticket.id}}) has been received and is being reviewed by our support staff.\n\nTo add additional # # comments, reply to this email.\n\n{{ticket.comments_formatted}}",
    #       id: 145382500448, recipients: [9343852848],
    #       subject: "[Request received] {{ticket.title}}", type: "Notification",
    #       via: %{channel: "rule",
    #         source: %{from: %{id: 64041887,
    #             title: "Notify requester of received request"}, rel: "trigger",
    #           to: %{}}}},
    #     %{body: "A ticket (\#{{ticket.id}}) by {{ticket.requester.name}} has been received. It is unassigned.\n\n{{ticket.comments_formatted}}",
    #       id: 145382500608, recipients: [1802891567],
    #       subject: "[{{ticket.account}}] {{ticket.title}}", type: "Notification",
    #       via: %{channel: "rule",
    #         source: %{from: %{id: 64041947,
    #             title: "Notify all agents of received request"}, rel: "trigger",
    #           to: %{}}}}], id: 145382499768,
    #    metadata: %{custom: %{},
    #      system: %{client: "Elixir/ExZendesk", ip_address: "173.65.209.214",
    #        latitude: 27.88669999999999, location: "Tampa, FL, United States",
    #        longitude: -82.5117}}, ticket_id: 173,
    #    via: %{channel: "api", source: %{from: %{}, rel: nil, to: %{}}}},
    #  ticket: %{allow_channelback: false, assignee_id: 1802891567,
    #    brand_id: 572847, collaborator_ids: [],
    #    created_at: "2016-08-12T16:40:14Z", custom_fields: [],
    #    description: "this is a test", due_at: nil, external_id: nil, fields: [],
    #    forum_topic_id: nil, group_id: 26814467, has_incidents: false, id: 173,
    #    organization_id: nil, priority: nil, problem_id: nil,
    #    raw_subject: "testing", recipient: nil, requester_id: 9343852848,
    #    satisfaction_rating: nil, sharing_agreement_ids: [], status: "open",
    #    subject: "testing", submitter_id: 9343852848, tags: [], type: nil,
    #    updated_at: "2016-08-12T16:40:14Z",
    #    url: "https://storestartup.zendesk.com/api/v2/tickets/173.json",
    #    via: %{channel: "api", source: %{from: %{}, rel: nil, to: %{}}}}},
    # headers: [{"Server", "nginx"}, {"Date", "Fri, 12 Aug 2016 16:40:14 GMT"},
    # {"Content-Type", "application/json; charset=UTF-8"},
    # {"Content-Length", "2665"}, {"Connection", "keep-alive"},
    # {"X-Zendesk-API-Version", "v2"},
    # {"X-Zendesk-Application-Version", "v3.94.2"},
    # {"X-Frame-Options", "SAMEORIGIN"},
    # {"Location", "https://partially.zendesk.com/api/v2/tickets/173.json"},
    # {"X-Rate-Limit", "700"}, {"X-Rate-Limit-Remaining", "699"},
    # {"Strict-Transport-Security", "max-age=31536000;"},
    # {"X-UA-Compatible", "IE=Edge,chrome=1"},
    # {"ETag", "\"71ffe41cfa9ce1e92dfd15a1de13822d\""},
    # {"Cache-Control", "max-age=0, private, must-revalidate"},
    # {"X-Zendesk-Origin-Server", "app44.pod6.iad1.zdsys.com"},
    # {"X-Request-Id", "deeaf0fd-e352-4102-c1e6-b8ca3a6bbce0"},
    # {"X-Runtime", "0.679025"}, {"X-Rack-Cache", "invalidate, pass"},
    # {"X-Zendesk-Request-Id", "4e1deda0879800940aeb"},
    # {"X-Content-Type-Options", "nosniff"}], status_code: 201}}
  ```

  """

  def process_url(url) do
    subdomain <> url
  end

  def process_response_body(body) do
    try do
      Poison.decode!(body, keys: :atoms)
    rescue
      _ -> body
    end
  end

  def process_request_headers(headers) do
    added_headers = [{"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"User-Agent", "Elixir/ExZendesk"},
      {"Authorization", "Basic " <> Base.encode64(user <> ":" <> password)}]
    headers ++ added_headers
  end

  def process_request_body(body) do
    Poison.encode! body
  end

  defp user do
    System.get_env("ZENDESK_USER") || Application.get_env(:ex_zendesk, :user)
  end

  defp password do
    System.get_env("ZENDESK_PASSWORD") || Application.get_env(:ex_zendesk, :password)
  end

  defp subdomain do
    System.get_env("ZENDESK_SUBDOMAIN") || Application.get_env(:ex_zendesk, :subdomain)
  end

end
