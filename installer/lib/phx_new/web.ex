defmodule Phx.New.Web do
  @moduledoc false
  use Phx.New.Generator
  alias Phx.New.{Project}

  @pre "phx_umbrella/apps/app_name_web"

  template :new, [
    {:config, "#{@pre}/config/config.exs",            :project, "config/config.exs"},
    {:config, "#{@pre}/config/dev.exs",               :project, "config/dev.exs"},
    {:config, "#{@pre}/config/prod.exs",              :project, "config/prod.exs"},
    {:prod_config, "#{@pre}/config/runtime.exs",      :project, "config/runtime.exs"},
    {:config, "#{@pre}/config/test.exs",              :project, "config/test.exs"},
    {:eex,  "#{@pre}/lib/app_name.ex",                :web, "lib/:web_app.ex"},
    {:eex,  "#{@pre}/lib/app_name/application.ex",    :web, "lib/:web_app/application.ex"},
    {:keep, "phx_web/controllers",                    :web, "lib/:web_app/controllers"},
    {:eex,  "phx_web/endpoint.ex",                    :web, "lib/:web_app/endpoint.ex"},
    {:eex,  "phx_web/router.ex",                      :web, "lib/:web_app/router.ex"},
    {:eex,  "phx_web/telemetry.ex",                   :web, "lib/:web_app/telemetry.ex"},
    {:eex,  "phx_web/views/error_view.ex",            :web, "lib/:web_app/views/error_view.ex"},
    {:eex,  "#{@pre}/mix.exs",                        :web, "mix.exs"},
    {:eex,  "#{@pre}/README.md",                      :web, "README.md"},
    {:eex,  "#{@pre}/gitignore",                      :web, ".gitignore"},
    {:keep, "phx_test/channels",                      :web, "test/:web_app/channels"},
    {:keep, "phx_test/controllers",                   :web, "test/:web_app/controllers"},
    {:eex,  "#{@pre}/test/test_helper.exs",           :web, "test/test_helper.exs"},
    {:eex,  "phx_test/support/conn_case.ex",          :web, "test/support/conn_case.ex"},
    {:eex,  "phx_test/views/error_view_test.exs",     :web, "test/:web_app/views/error_view_test.exs"},
    {:eex,  "#{@pre}/formatter.exs",                  :web, ".formatter.exs"},
  ]

  template :gettext, [
    {:eex,  "phx_gettext/gettext.ex",               :web, "lib/:web_app/gettext.ex"},
    {:eex,  "phx_gettext/en/LC_MESSAGES/errors.po", :web, "priv/gettext/en/LC_MESSAGES/errors.po"},
    {:eex,  "phx_gettext/errors.pot",               :web, "priv/gettext/errors.pot"}
  ]

  template :html, [
    {:eex, "phx_web/components.ex",                         :web, "lib/:web_app/components.ex"},
    {:eex, "phx_web/controllers/page_controller.ex",        :web, "lib/:web_app/controllers/page_controller.ex"},
    {:eex, "phx_web/views/layout_view.ex",                  :web, "lib/:web_app/views/layout_view.ex"},
    {:eex, "phx_web/views/page_view.ex",                    :web, "lib/:web_app/views/page_view.ex"},
    {:eex, "phx_test/controllers/page_controller_test.exs", :web, "test/:web_app/controllers/page_controller_test.exs"},
    {:eex, "phx_test/views/page_view_test.exs",             :web, "test/:web_app/views/page_view_test.exs"},
    {:eex, "phx_live/assets/topbar.js",                     :web, "assets/vendor/topbar.js"},
    {:eex, "phx_web/templates/layout/root.html.heex",       :web, "lib/:web_app/templates/layout/root.html.heex"},
    {:eex, "phx_web/templates/layout/app.html.heex",        :web, "lib/:web_app/templates/layout/app.html.heex"},
    {:eex, "phx_web/templates/page/index.html.heex",        :web, "lib/:web_app/templates/page/index.html.heex"},
    {:eex, "phx_test/views/layout_view_test.exs",           :web, "test/:web_app/views/layout_view_test.exs"},
  ]

  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    web_path = Path.expand(project.base_path)
    project_path = Path.dirname(Path.dirname(web_path))

    %Project{project |
             in_umbrella?: true,
             project_path: project_path,
             web_path: web_path,
             web_app: app,
             generators: [context_app: false],
             web_namespace: project.app_mod}
  end

  def generate(%Project{} = project) do
    inject_umbrella_config_defaults(project)
    copy_from project, __MODULE__, :new

    if Project.html?(project), do: gen_html(project)
    if Project.gettext?(project), do: gen_gettext(project)

    Phx.New.Single.gen_assets(project)
    project
  end

  defp gen_html(%Project{} = project) do
    copy_from project, __MODULE__, :html
  end

  defp gen_gettext(%Project{} = project) do
    copy_from project, __MODULE__, :gettext
  end
end
