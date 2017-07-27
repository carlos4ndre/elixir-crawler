defmodule SiteMap.Validation do
  @supported_schemes ["http", "https"]

  def url_valid?(str) do
    uri = URI.parse(str)
    case uri do
      %URI{scheme: scheme} when scheme not in @supported_schemes -> false
      %URI{host: nil} -> false
      _ -> true
    end
  end
end
